package flixel;

/**
 * This is a useful "generic" Flixel object. Both `FlxObject` and
 * `FlxGroup` extend this class. Has no size, position or graphical data.
 */
class FlxBasic {
	/**
	 * Controls whether `update()` is automatically called by `FlxState`/`FlxGroup`.
	 */
	public var active:Bool = true;

	/**
	 * Controls whether `draw()` is automatically called by `FlxState`/`FlxGroup`.
	 */
	public var visible:Bool = true;

	/**
	 * Useful state for many game objects - "dead" (`!alive`) vs `alive`. `kill()` and
	 * `revive()` both flip this switch (along with `exists`, but you can override that).
	 */
	public var alive:Bool = true;

	/**
	 * Controls whether `update()` and `draw()` are automatically called by `FlxState`/`FlxGroup`.
	 */
	public var exists:Bool = true;

	/**
	 * Gets or sets the first camera of this object.
	 */
	public var camera(get, set):FlxCamera;

	/**
	 * This determines on which `FlxCamera`s this object will be drawn. If it is `null` / has not been
	 * set, it uses the list of default draw targets, which is controlled via `FlxG.camera.setDefaultDrawTarget`
	 * as well as the `DefaultDrawTarget` argument of `FlxG.camera.add`.
	 */
	public var cameras:Array<FlxCamera> = [];

	/**
	 * Override this function to update your class's position and appearance.
	 * This is where most of your game rules and behavioral code will go.
	 */
	public function update(delta:Float):Void {}

	/**
	 * Override this function to update your class's position and appearance.
	 * This is where most of your game rules and behavioral code will go.
	 */
	public function draw(delta:Float):Void {}

	// [ PRIVATES ] //

	@:noCompletion
	private function get_camera():FlxCamera {
		return cameras[0];
	}

	@:noCompletion
	private function set_camera(newCamera:FlxCamera):FlxCamera {
		if(cameras == null || cameras.length == 0)
			cameras = [newCamera];
		else
			cameras[0] = newCamera;

		return newCamera;
	}
}