package canvas;

/**
 * An updatable and drawable canvas that can
 * contain other canvases within it.
 * 
 * This class is designed to have similar functionality
 * to OpenFL's Sprite class.
 * 
 * Mainly used for `FlxGame`, but can be used for
 * custom debug menus, framerate counters, anything you need!
 */
class Canvas {
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
	 * The children of this canvas.
	 */
	public var children(default, null):Array<Canvas> = [];

	/**
	 * The parent of this canvas.
	 */
	public var parent(default, null):Canvas = null;

	/**
	 * Makes a new `Canvas` instance.
	 */
	public function new() {}

	/**
	 * Adds a child canvas to this canvas.
	 */
	public function addChild(canvas:Canvas) {
		if(children.contains(canvas)) {
			trace("Child canvas was already added to it's parent!");
			return;
		}
		canvas.parent = this;
		children.push(canvas);
	}

	/**
	 * Adds a child canvas at a specified layer to this canvas.
	 */
	public function insertChild(layer:Int, canvas:Canvas) {
		if(children.contains(canvas)) {
			trace("Child canvas was already added to it's parent!");
			return;
		}
		canvas.parent = this;
		children.insert(layer, canvas);
	}

	/**
	 * Removes a child canvas from this canvas.
	 */
	public function removeChild(canvas:Canvas) {
		if(!children.contains(canvas)) {
			trace("Child canvas doesn't have a parent!");
			return;
		}
		canvas.parent = null;
		children.remove(canvas);
	}

	/**
	 * Puts this canvas into a new parent canvas.
	 */
	public function reparent(newParent:Canvas) {
		parent.removeChild(this);
		newParent.addChild(this);
	}

	/**
	 * Updates this canvas object.
	 * Override this function to update your own stuff aswell!
	 * 
	 * @param  delta  The time between the last frame in seconds.
	 */
	public function update(delta:Float) {}

	/**
	 * Draws this canvas object.
	 * Override this function to draw your own stuff aswell!
	 */
	public function draw() {}
}