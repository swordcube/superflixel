package canvas.backend;

import haxe.xml.Access;

import canvas.backend.Application.ApplicationConfig;

import flixel.system.macros.FlxDefines;

using StringTools;

/**
 * A utility class for handling project files.
 */
class Project {
	/**
	 * Parses a given project xml into application configuration data.
	 */
	public static function parseXmlConfig(xml:Xml):ApplicationConfig {
		final data:Access = cast (xml.nodeType == Element ? xml : xml.firstElement());
		final parsed:ApplicationConfig = {
			defined: [
				"windows" => (Sys.systemName() == "Windows") ? "1" : "0",
				"linux"   => (Sys.systemName() == "Linux")   ? "1" : "0",
				"bsd"     => (Sys.systemName() == "BSD")     ? "1" : "0",
				"mac"     => (Sys.systemName() == "Mac")     ? "1" : "0",
				"macos"   => (Sys.systemName() == "Mac")     ? "1" : "0"
			],

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
			haxeflags: [],

			icon: null
		};

		final desktopSystems:Array<String> = [parsed.defined.get("windows"), parsed.defined.get("linux"), parsed.defined.get("mac")];
		parsed.defined.set("desktop", (desktopSystems.contains("1") || desktopSystems.contains("true")) ? "true" : "false");

		function resolveStringIf(defines:Map<String, String>, condition:String, checkParenthCount:Bool):Bool {
			if (checkParenthCount && condition.contains("(")) {
				var leftCount:Int = 0;
				var rightCount:Int = 0;
				var countIndex:Int = -1;
				while ((countIndex = condition.indexOf("(", countIndex)) >= 0)
					leftCount++;

				countIndex = -1;
				while ((countIndex = condition.indexOf(")", countIndex)) >= 0) // please tell me theres a better way of counting these strings
					rightCount++;

				if (leftCount != rightCount)
					throw 'Unable to parse condition "${condition}": Unmatched parenthesis count. $leftCount "(" | $rightCount ")")';
			}

			if (condition.contains("||")) {
				var toReturn:Bool = false;
				for (split in condition.split("||"))
					toReturn = toReturn || resolveStringIf(defines, split.trim(), false);
				return toReturn;
			}
			if (condition.contains("&&")) {
				for (split in condition.split("&&")) {
					if (!resolveStringIf(defines, split.trim(), false))
						return false;
				}
				return true;
			}
			return (defines[condition] == null || defines[condition] == "0" || defines[condition] == "false");
		}

		function parseElementsInXml(data:Access) {
			for(element in data.elements) {
				var canRun:Bool = true;

				final defines:Map<String, String> = FlxDefines.getAllDefines();
				if(element.has.resolve("if"))
					canRun = resolveStringIf(defines, element.att.resolve("if"), true);
				
				if(element.has.resolve("unless"))
					canRun = canRun && !resolveStringIf(defines, element.att.resolve("unless"), true);

				if (!canRun)
					continue;
	
				switch(element.name.toLowerCase()) {
					case "section":
						parseElementsInXml(element); // recursion 🤯 

					case "app", "window":
						for(attName in element.x.attributes()) {
							final value:String = element.att.resolve(attName);
							Reflect.setField(parsed, attName, value);
						}
	
					case "set", "define":
						parsed.defined.set(element.att.name, element.has.value ? element.att.value : "1");
					
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

					case "haxeflag":
						parsed.haxeflags.push({
							name: element.att.name,
							value: element.has.value ? element.att.value : "1"
						});
				}
			}
		}
		parseElementsInXml(data);

		return parsed;
	}
}