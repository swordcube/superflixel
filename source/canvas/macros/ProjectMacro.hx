package canvas.macros;

import sys.io.File;
import sys.FileSystem;
import haxe.io.Path;

#if macro
import haxe.macro.*;
import haxe.macro.Expr;
#end

#if (macro || !eval)
import canvas.backend.Application;
import canvas.backend.Application.ApplicationConfig;
#end

import canvas.backend.Project;
import flixel.util.FlxFileUtil;

#if macro
using haxe.macro.PositionTools;
#end
using StringTools;

@:keep
class ProjectMacro {
	public static macro function build():Array<Field> {
		#if (macro || !eval)
		final pos = Context.currentPos();
		final posInfo = pos.getInfos();

		var sourcePath:String = Path.directory(posInfo.file);
		if (!Path.isAbsolute(sourcePath))
			sourcePath = Path.join([Sys.getCwd(), sourcePath]);

		sourcePath = Path.normalize(sourcePath);

		final xmlPath:String = Path.normalize(Path.join([sourcePath, "project.xml"]));
		if (!FileSystem.exists(xmlPath))
			Context.fatalError('Couldn\'t find a valid "project.xml" file!', pos);

		final cfg:ApplicationConfig = Project.parseXmlConfig(Xml.parse(File.getContent(xmlPath)));
		final platform:String = Sys.systemName().toLowerCase();

		// Copy specified asset folders to export folder
		for (folder in cfg.assetFolders) {
			final dirToCopy:String = Path.normalize(Path.join([sourcePath, folder]));
			final destDir:String = Path.normalize(Path.join([sourcePath, cfg.defined.get("BUILD_DIR") ?? "export", platform, "bin", folder]));
			FlxFileUtil.copyDirectory(dirToCopy, destDir);
		}
		return Context.getBuildFields();
		#else
		return null;
		#end
    }

	public static macro function getConfigDir():Expr {
		return macro $v{Path.normalize(Sys.getCwd())};
	}

	public static macro function getConfig():Expr {
		final cwd:String = Path.normalize(Sys.getCwd());
		final xmlPath:String = Path.normalize(Path.join([cwd, "project.xml"]));

		if (!FileSystem.exists(xmlPath))
			Context.fatalError('Couldn\'t find a valid "project.xml" file! ' + xmlPath, Context.currentPos());

		final content:String = File.getContent(xmlPath);
		return macro $v{content};
	}
}