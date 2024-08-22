package canvas.backend;

/**
 * A simple class that holds RGB values for a color.
 */
class Color {
	/**
	 * The red channel of this color. Ranges from `0.0` - `1.0`.
	 */
	public var r:Float = 0;

	/**
	 * The green channel of this color. Ranges from `0.0` - `1.0`.
	 */
	public var g:Float = 0;

	/**
	 * The blue channel of this color. Ranges from `0.0` - `1.0`.
	 */
	public var b:Float = 0;

	/**
	 * The alpha channel of this color. Ranges from `0.0` - `1.0`.
	 */
	public var a:Float = 1;

	/**
	 * Returns a new `Color`.
	 */
	public function new(r:Float = 0, g:Float = 0, b:Float = 0, a:Float = 1) {
		set(r, g, b, a);
	}

	/**
	 * Sets the RGBA components of this color to any
	 * values specified.
	 * 
	 * @param r  The new value for the red component.
	 * @param g  The new value for the green component.
	 * @param b  The new value for the blue component.
	 * @param a  The new value for the alpha component.
	 */
	public function set(r:Float = 0, g:Float = 0, b:Float = 0, a:Float = 1) {
		this.r = r;
		this.g = g;
		this.b = b;
		this.a = a;
		return this;
	}
}