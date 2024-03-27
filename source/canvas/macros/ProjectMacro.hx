package canvas.macros;

import sys.io.File;
import sys.FileSystem;
import haxe.io.Path;

#if macro
import haxe.macro.*;
import haxe.macro.Expr;
#end

#if (macro || !eval)
import flixel.util.FlxFileUtil;
import canvas.backend.Application;
import canvas.backend.Application.ApplicationConfig;
#end

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

		final cfgPath:String = Path.normalize(Path.join([sourcePath, "project.cfg"]));
		if (!FileSystem.exists(cfgPath))
			Context.fatalError('Couldn\'t find a valid "project.cfg" file!', pos);

		final cfg:ApplicationConfig = Application.parseXmlConfig(Xml.parse(File.getContent(cfgPath)));
		final platform:String = Sys.systemName().toLowerCase();

		// Copy specified asset folders to export folder
		for (folder in cfg.assetFolders) {
			final dirToCopy:String = Path.normalize(Path.join([sourcePath, folder]));
			final destDir:String = Path.normalize(Path.join([sourcePath, cfg.defined.get("BUILD_DIR") ?? "export", platform, "bin", folder]));
			FileUtil.copyDirectory(dirToCopy, destDir);
		}
		return Context.getBuildFields();
		#else
		return null;
		#end
    }
}