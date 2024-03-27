package canvas.backend;

// TODO: make this real :3
/**
 * A basic window class that can contain canvases.
 */
class Window {
	/**
	 * Adds a canvas to this window.
	 */
	public function addCanvas(canvas:Canvas) {
		if(_canvases.contains(canvas)) {
			trace("This window already contains this canvas!");
			return;
		}
		_canvases.push(canvas);
	}

	/**
	 * Removes a canvas from this window.
	 */
	public function removeCanvas(canvas:Canvas) {
		if(!_canvases.contains(canvas)) {
			trace("This window doesn't contain this canvas!");
			return;
		}
		_canvases.remove(canvas);
	}

	// [ PRIVATE ] //
	
	private var _canvases:Array<Canvas> = [];
}