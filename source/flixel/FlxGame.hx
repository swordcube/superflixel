package flixel;

import canvas.CanvasObject;

/**
 * `FlxGame` is the heart of all Flixel games, and contains a bunch of basic game loops and things.
 * It is a long and sloppy file that you shouldn't have to worry about too much!
 * 
 * It is basically only used to create your game object in the first place,
 * after that `FlxG` and `FlxState` have all the useful stuff you actually need.
 */
@:allow(flixel.FlxG)
class FlxGame extends CanvasObject {
	/**
	 * Makes a new `FlxGame` instance.
	 */
	public function new() {
		super();
	}
}