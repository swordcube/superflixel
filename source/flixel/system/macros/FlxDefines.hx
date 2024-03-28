package flixel.system.macros;

import haxe.macro.Context;
import haxe.macro.Compiler;
import haxe.macro.Expr.Position;

using StringTools;

private enum UserDefines {
	FLX_NO_GAMEPAD;
	FLX_NO_MOUSE;
	FLX_NO_TOUCH;
	FLX_NO_KEYBOARD;
	FLX_NO_SOUND_SYSTEM;
	FLX_NO_SOUND_TRAY;
	FLX_NO_FOCUS_LOST_SCREEN;
	FLX_NO_DEBUG;
	FLX_NO_HEALTH;
	FLX_RECORD;
	FLX_NO_POINT_POOL;
	FLX_NO_PITCH;
	FLX_NO_SAVE;
}

/**
 * These are "typedef defines" - complex #if / #elseif conditions
 * are shortened into a single define to avoid the redundancy
 * that comes with using them frequently.
 */
private enum HelperDefines {
	FLX_GAMEPAD;
	FLX_MOUSE;
	FLX_TOUCH;
	FLX_KEYBOARD;
	FLX_SOUND_SYSTEM;
	FLX_FOCUS_LOST_SCREEN;
	FLX_DEBUG;
	FLX_STEAMWRAP;
	FLX_SOUND_TRAY;
	FLX_POINTER_INPUT;
	FLX_POST_PROCESS;
	FLX_JOYSTICK_API;
	FLX_GAMEINPUT_API;
	FLX_ACCELEROMETER;
	FLX_POINT_POOL;
	FLX_PITCH;
	FLX_SAVE;
	FLX_HEALTH;
}

class FlxDefines {
	public static function run():Void {
		#if !display
		checkDefines();
		#end

		defineInversions();
		defineHelperDefines();
	}

	public static function getAllDefines():Map<String, String> {
		#if macro
		return Context.getDefines();
		#else
		return [];
		#end
	}

	private static function checkDefines() {
		#if macro
		for (define in HelperDefines.getConstructors())
			abortIfDefined(define);

		for (define in Context.getDefines().keys()) {
			if (isValidUserDefine(define)) {
				Context.warning('"$define" is not a valid SuperFlixel define.', (macro null).pos);
			}
		}
		#end
	}

	private static var userDefinable = UserDefines.getConstructors();

	private static function isValidUserDefine(define:String) {
		return
			(define.startsWith("FLX_") && userDefinable.indexOf(define) == -1);
	}

	private static function abortIfDefined(define:String) {
		if (defined(define))
			abort('$define can only be defined by SuperFlixel.', (macro null).pos);
	}

	private static function defineInversions() {
		defineInversion(FLX_NO_GAMEPAD, FLX_GAMEPAD);
		defineInversion(FLX_NO_MOUSE, FLX_MOUSE);
		defineInversion(FLX_NO_TOUCH, FLX_TOUCH);
		defineInversion(FLX_NO_KEYBOARD, FLX_KEYBOARD);
		defineInversion(FLX_NO_SOUND_SYSTEM, FLX_SOUND_SYSTEM);
		defineInversion(FLX_NO_FOCUS_LOST_SCREEN, FLX_FOCUS_LOST_SCREEN);
		defineInversion(FLX_NO_DEBUG, FLX_DEBUG);
		defineInversion(FLX_NO_POINT_POOL, FLX_POINT_POOL);
		defineInversion(FLX_NO_HEALTH, FLX_HEALTH);
	}

	private static function defineHelperDefines() {
		if (!defined(FLX_NO_SOUND_SYSTEM) && !defined(FLX_NO_SOUND_TRAY))
			define(FLX_SOUND_TRAY);

		if (defined(FLX_NO_SOUND_SYSTEM))
			define(FLX_NO_PITCH);

		if (!defined(FLX_NO_PITCH))
			define(FLX_PITCH);

		if (!defined(FLX_NO_SAVE))
			define(FLX_SAVE);

		if (!defined("flash") || defined("flash11_8"))
			define(FLX_GAMEINPUT_API);
		else if (!defined("openfl_next") && (defined("cpp") || defined("neko")))
			define(FLX_JOYSTICK_API);

		if (!defined(FLX_NO_TOUCH) || !defined(FLX_NO_MOUSE))
			define(FLX_POINTER_INPUT);

		if (defined("cpp") || defined("neko"))
			define(FLX_POST_PROCESS);

		if (defined("cpp") && defined("steamwrap"))
			define(FLX_STEAMWRAP);

		if (defined("mobile") || defined("js"))
			define(FLX_ACCELEROMETER);
	}

	private static function defineInversion(userDefine:UserDefines, invertedDefine:HelperDefines) {
		if (!defined(userDefine))
			define(invertedDefine);
	}

	static inline function defined(define:Dynamic) {
		#if macro
		return Context.defined(Std.string(define));
		#else
		return false;
		#end
	}

	static inline function define(define:Dynamic) {
		#if macro
		Compiler.define(Std.string(define));
		#end
	}

	private static function abort(message:String, pos:Position) {
		#if macro
		Context.fatalError(message, pos);
		#end
	}
}
