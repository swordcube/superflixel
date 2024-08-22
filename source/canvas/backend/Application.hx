package canvas.backend;

#if (!macro && !eval)
import sdl.SDL;
import sdl.Types.InitFlags;
#end

#if !macro
import canvas.macros.ProjectMacro;
#end

typedef HaxelibSection = {
	var name:String;
	var ?version:String;
	var ?optional:String;
}

typedef HaxedefSection = {
	var name:String;
	var value:String;
}

typedef HaxeflagSection = {
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

	// <haxeflag/>
	var haxeflags:Array<HaxedefSection>;

	// <icon/>
	var icon:String;
}

#if !macro
@:autoBuild(canvas.macros.ApplicationMacro.build())
class Application extends Canvas {
	/**
	 * The current application instance.
	 */
	public static var current:Application;

	/**
	 * The configuration data for this application.
	 */
	public var meta:ApplicationConfig;

	/**
	 * The main window of this application.
	 */
	public var window:Window;

	/**
	 * Makes a new `Application` instance.
	 */
	public function new() {
		super();
		if(current == null)
			current = this;

		meta = Project.parseXmlConfig(Xml.parse(ProjectMacro.getConfig()));
	}

	/**
	 * Starts this application.
	 */
	public function start() {
		#if (!macro && !eval)
		SDL.init(VIDEO | EVENTS);
		window = new Window(meta.title, 0x2FFF0000, 0x2FFF0000, Std.parseInt(meta.window.width), Std.parseInt(meta.window.height));
		#end
	}
}
#else
class Application {
	public function new() {}
}
#end