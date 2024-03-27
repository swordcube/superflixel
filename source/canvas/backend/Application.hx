package canvas.backend;

import haxe.xml.Access;
import haxe.macro.Compiler;
import haxe.macro.ExprTools;

typedef HaxelibSection = {
	var name:String;
	var ?version:String;
	var ?optional:String;
}

typedef HaxedefSection = {
	var name:String;
	var value:String;
}

typedef WindowSection = {
	var width:String;
	var height:String;
	var fps:String;
	var background:String; // color as string :D
	var vsync:String;
	var orientation:String; // landscape or portrait
	var fullscreen:String;
	var resizable:String;
}

/**
 * The configuration data for an application.
 */
// ! - Make <section if="shit"> work!!
typedef ApplicationConfig = {
	// <misc/>
	var defined:Map<String, String>; // set using <set/> or <define/>

	// <app/>
	var title:String;
	var file:String;
	var main:String;
	var version:String;
	var company:String;

	// <window/>
	var window:WindowSection;

	// <source/>
	var source:String;

	// <assets/>
	var assetFolders:Array<String>;

	// <haxelib/>
	var haxelibs:Array<HaxelibSection>;

	// <haxedef/>
	var haxedefs:Array<HaxedefSection>;

	// <icon/>
	var icon:String;
}

@:autoBuild(canvas.macros.ApplicationMacro.build())
class Application {
	/**
	 * The current application instance.
	 */
	public static var self:Application;

	/**
	 * The configuration data for this application.
	 */
	public var config:ApplicationConfig;

	/**
	 * Parses a given project xml into application configuration data.
	 */
	public static function parseXmlConfig(xml:Xml) {
		final data:Access = cast (xml.nodeType == Element ? xml : xml.firstElement());
		final parsed:ApplicationConfig = {
			defined: [],

			title: "SuperFlixel Project",
			file: "Main",
			main: "Main",
			version: "0.0.1",
			company: "SuperFlixel",

			window: {
				width: "640",
				height: "480",
				fps: "0",
				background: "#000000",
				vsync: "false",
				orientation: "landscape",
				fullscreen: "false",
				resizable: "true"
			},

			source: "source",
			assetFolders: [],

			haxelibs: [],
			haxedefs: [],

			icon: null
		};

		function parseElementsInXml(data:Access) {
			for(element in data.elements) {
				final key:String = element.att.resolve("if");
				final defineValue:String = Compiler.getDefine(key); // this errors and idk why
				final ifValue:String = (element.has.resolve("if")) ? defineValue ?? parsed.defined.get(key) : null;
				final unlessValue:String = (element.has.resolve("unless")) ? parsed.defined.get(element.att.resolve("unless")) : null;
				
				final canRun:Bool = !(ifValue == null || ifValue == "0" || ifValue == "false") && (unlessValue == null || unlessValue == "0" || unlessValue == "false");
				if (!canRun)
					continue;
	
				switch(element.name.toLowerCase()) {
					case "section":
						parseElementsInXml(element); // recursion 🤯 

					case "app", "window":
						final attNames:Array<String> = [for(n in element.x.attributes()) n];
						for(attName in attNames) {
							final value:String = element.att.resolve(attName);
							Reflect.setField(parsed, attName, value);
						}
	
					case "set", "define":
						parsed.defined.set(element.att.name, element.att.value);
					
					case "source":
						parsed.source = element.att.path;
	
					case "assets":
						parsed.assetFolders.push(element.att.path);

					case "haxelib":
						parsed.haxelibs.push({
							name: element.att.name,
							version: element.has.version ? element.att.version : null
						});
						
					case "haxedef":
						parsed.haxedefs.push({
							name: element.att.name,
							value: element.has.value ? element.att.value : "1"
						});
				}
			}
		}
		parseElementsInXml(data);

		return parsed;
	}

	/**
	 * Makes a new `Application`.
	 */
	public function new() {
		if(self == null)
			self = this;
	}

	/**
	 * Starts this application.
	 */
	public function start() {

	}
}