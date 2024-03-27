package canvas;

/**
 * An updatable and drawable canvas object that can
 * be placed on a canvas layer.
 * 
 * Mainly used for `FlxGame`, but can be used for
 * custom debug menus, framerate counters, anything you need!
 */
class CanvasObject {
	/**
	 * The X coordinate of this object starting
	 * from the top-left corner of the window.
	 */
	public var x:Float = 0;

	/**
	 * The Y coordinate of this object starting
	 * from the top-left corner of the window.
	 */
	public var y:Float = 0;

	/**
	 * Makes a new `CanvasObject` instance.
	 */
	public function new() {}

	/**
	 * Updates this canvas object.
	 * Override this function to update your own stuff aswell!
	 * 
	 * @param  delta  The time between the last frame in seconds.
	 */
	public function update(delta:Float) {}

	/**
	 * Draws this canvas object.
	 */
	public function draw() {}
}