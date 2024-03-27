package flixel;

/**
 * The camera class is used to display the game's visuals.
 * By default one camera is created automatically, that is the same size as the window.
 * You can add more cameras or even replace the main camera using utilities in `FlxG.cameras`.
 */
class FlxCamera extends FlxBasic {
	// [ PRIVATE ] //
	
	@:noCompletion
	override function get_camera():FlxCamera {
		throw "This functionality is unsupported in FlxCamera!";
	}

	@:noCompletion
	override function set_camera(newCamera:FlxCamera):FlxCamera {
		throw "This functionality is unsupported in FlxCamera!";
	}
}