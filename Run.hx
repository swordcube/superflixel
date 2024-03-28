package;

import haxe.io.Path;
import haxe.io.Bytes;

import sys.io.File;
import sys.FileSystem;

import canvas.macros.ProjectMacro;

import canvas.backend.Project;
import canvas.backend.Application.ApplicationConfig;

import flixel.util.FlxFileUtil;

using StringTools;

typedef Command = {
	var name:String;
	var description:String;
	var method:Void->Void;
}

class Run {
	static final cmds:Array<Command> = [
		{
			name: "help",
			description: "Lists every available command.",
			method: () -> {
				Sys.print("\r\n--========##[ Command List ]##========--\r\n\r\n");
				for (cmd in cmds)
					Sys.print('${cmd.name} - ${cmd.description}\r\n');
				Sys.print("\r\n--========####################========--\r\n\r\n");
			}
		},
		{
			name: "create",
			description: "Create a fresh SuperFlixel project.",
			method: () -> {
				final emptyZipFile:String = Path.normalize(Path.join([ProjectMacro.getConfigDir(), "projects", "empty.zip"]));
				final args:Array<String> = Sys.args() ?? [];
				final curDir:String = Path.normalize(args[args.length - 1]);
				Sys.print('Please input the name of the new project. (Will be created in ${curDir})\r\n');
				try {
					final result:String = Sys.stdin().readLine().toString();
					final newDir:String = Path.normalize(Path.join([curDir, result]));
					if (FileSystem.exists(newDir)) {
						Sys.print('Project at ${newDir} already exists! Please delete it before continuing.');
						return;
					} else {
						Sys.print('Creating project at ${newDir}...\r\n');
						FileSystem.createDirectory(newDir);
						FlxFileUtil.unzipFile(emptyZipFile, newDir);
					}
					Sys.print('Project at ${newDir} has been created!');
				} catch (e) {}
			}
		},
		{
			name: "build",
			description: "Build a SuperFlixel project.",
			method: buildProj.bind(false)
		},
		{
			name: "test",
			description: "Build and run a SuperFlixel project.",
			method: buildProj.bind(true)
		},
		{
			name: "run",
			description: "Run a SuperFlixel project.",
			method: runProj
		}
	];

	static function main() {
		var isValidCMD:Bool = false;
		final args:Array<String> = Sys.args() ?? [];
		for (cmd in cmds) {
			if (args[0] == cmd.name) {
				isValidCMD = true;
				if (cmd.method != null)
					cmd.method();
				break;
			}
		}
		if (!isValidCMD) {
			final asciiArt:String = "
                                   _____.__  .__              .__   
  ________ ________   ____________/ ____\\  | |__|__  ___ ____ |  |  
 /  ___/  |  \\____ \\_/ __ \\_  __ \\   __\\|  | |  \\  \\/  // __ \\|  |  
 \\___ \\|  |  /  |_> >  ___/|  | \\/|  |  |  |_|  |>    <\\  ___/|  |__
/____  >____/|   __/ \\___  >__|   |__|  |____/__/__/\\_ \\\\___  >____/
     \\/      |__|        \\/                           \\/    \\/      
            \r\n";
			Sys.print(asciiArt);
			
			Sys.print("Welcome to SuperFlixel, a remake of HaxeFlixel without Lime or OpenFL.\r\n\r\n");
			Sys.print("Type in \"haxelib run superflixel help\" for a list of every available command!\r\n");
		}
	}

	static function buildProj(?runAfterBuild:Bool = false) {
		final libDir:String = Sys.getCwd();

        final sysArgs:Array<String> = Sys.args();
        final curDir:String = sysArgs[sysArgs.length - 1];

		if (!FileSystem.exists('${curDir}project.xml')) {
			Sys.print("[ERROR] A project.xml file couldn't be found in the current directory.\r\n");
			return;
		}
		final args:Array<String> = [];
		final cfg:ApplicationConfig = Project.parseXmlConfig(Xml.parse(File.getContent('${curDir}project.xml')));
		
        args.push('--class-path ${cfg.source}');
		
		for (lib in cfg.haxelibs)
			args.push('--library ${lib.name}${(lib.version != null && lib.version.length != 0) ? ":"+lib.version : ""}');

		final x32:String = cfg.defined.get("32") ?? cfg.defined.get("32_BIT") ?? "0";
        if (x32 == "1" || x32.toLowerCase() == "true")
            args.push('--define HXCPP_M32');

		for (flag in cfg.haxeflags)
			args.push('${flag.name} ${flag.value}');

		args.push('--main ${cfg.main}');

		final buildDir:String = cfg.defined.get("BUILD_DIR") ?? "export";
		final platform:String = Sys.systemName().toLowerCase();

		args.push('--cpp ${buildDir}/${platform}/obj');
		
		if(args[1] == "-debug" || args[1] == "--debug")
			args.push("--debug");
		
		Sys.setCwd(curDir);

		final binFolder:String = Path.normalize(Path.join([curDir, buildDir, platform, "bin"]));
		if(!FileSystem.exists(binFolder))
			FileSystem.createDirectory(binFolder);
			
		final compileError:Int = Sys.command('haxe ${args.join(" ")}');
		if(compileError == 0) {
			Sys.setCwd(Path.normalize(Path.join([curDir, buildDir, platform, "obj"])));
			
			if(Sys.systemName() == "Windows") { // Windows
				final exePath:String = Path.normalize(Path.join([binFolder, '${cfg.file}.exe']));
				File.copy(
					Path.normalize(Path.join([Sys.getCwd(), '${cfg.main.substring(cfg.main.lastIndexOf(".") + 1)}.exe'])),
					exePath
				);
				for(file in FileSystem.readDirectory(Sys.getCwd())) {
					if(Path.extension(file) == "dll") {
						File.copy(
							Path.normalize(Path.join([Sys.getCwd(), file])),
							Path.normalize(Path.join([binFolder, file]))
						);
					}
				}
				final curIcon:String = cfg.icon ?? "icon.png";
				final projIconDir:String = Path.normalize(Path.join([curDir, curIcon]));
				final outputIconDir:String = Path.normalize(Path.join([binFolder, "icon.ico"]));
				
				// Generate ico file
				Sys.setCwd(Path.normalize(Path.join([libDir, "helpers", "windows", "magick"])));
				Sys.command("convert.exe", ["-resize", "256x256", FileSystem.exists(projIconDir) ? projIconDir : Path.normalize(Path.join([libDir, "icon.png"])), outputIconDir]);
				
				// Apply icon to exe file
				Sys.setCwd(Path.normalize(Path.join([libDir, "helpers", "windows"])));
				Sys.command("ReplaceVistaIcon.exe", [exePath, outputIconDir]);
				
				// Output warning if intended icon doesn't exist
				if(!FileSystem.exists(projIconDir))
					Sys.print('[WARNING] Icon file "${curIcon}" doesn\'t exist in the project directory!.\r\n');
				
			} else { // Linux/MacOS (Maybe BSD too, I forgot how BSD works)
				File.copy(
					Path.normalize(Path.join([Sys.getCwd(), '${cfg.main.substring(cfg.main.lastIndexOf(".") + 1)}'])),
					Path.normalize(Path.join([binFolder, '${cfg.file}']))
				);
				Sys.setCwd(binFolder);
				Sys.command('chmod +x "${cfg.file}"');
			}
			if(runAfterBuild)
				runProj();
		}
	}

	static function runProj() {
        final sysArgs:Array<String> = Sys.args();
        final curDir:String = sysArgs[sysArgs.length - 1];

		if (!FileSystem.exists('${curDir}project.xml')) {
			Sys.print("[ERROR] A project.xml file couldn't be found in the current directory.\r\n");
			return;
		}
		final cfg:ApplicationConfig = Project.parseXmlConfig(Xml.parse(File.getContent('${curDir}project.xml')));
		
		final buildDir:String = cfg.defined.get("BUILD_DIR") ?? "export";
		final platform:String = Sys.systemName().toLowerCase();

		Sys.setCwd(curDir);
		if(Sys.systemName() == "Windows") { // Windows
			final exec:String = Path.normalize(Path.join([curDir, buildDir, platform, "bin"]));
			if(FileSystem.exists(exec)) {
				Sys.setCwd(exec);
				Sys.command('"${cfg.file}.exe"');
			}
		} else { // Linux/MacOS (Maybe BSD too, I forgot how BSD works)
			final exec:String = Path.normalize(Path.join([curDir, buildDir, platform, "bin"]));
			if(FileSystem.exists(exec)) {
				Sys.setCwd(exec);
				Sys.command('"./${cfg.file}"');
			}
		}
	}
}