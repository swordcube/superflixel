package flixel.math;

/**
 * 2-dimensional point class
 */
@:transitive
abstract FlxPoint(IFlxPoint) from IFlxPoint to IFlxPoint {
	/**
	 * A point set to `0, 0`.
	 */
	public static var ZERO:FlxPoint = new FlxPoint();

	/**
	 * A point set to `1, 1`.
	 */
	public static var ONE:FlxPoint = new FlxPoint(1, 1);

	/**
	 * A point set to `0, -1`, indicating direction pointing up.
	 */
	public static var UP:FlxPoint = new FlxPoint(0, -1);

	/**
	 * A point set to `0, 1`, indicating direction pointing down.
	 */
	public static var DOWN:FlxPoint = new FlxPoint(0, 1);

	/**
	 * A point set to `-1, 0`, indicating direction pointing left.
	 */
	public static var LEFT:FlxPoint = new FlxPoint(-1, 0);

	/**
	 * A point set to `1, 0`, indicating direction pointing right.
	 */
	public static var RIGHT:FlxPoint = new FlxPoint(1, 0);

	/**
	 * Makes a new `FlxPoint` instance.
	 * 
	 * @param  x  The X coordinate of this point.
	 * @param  y  The Y coordinate of this point.
	 */
	public function new(?x:Float, ?y:Float) {
		set(x, y);
	}

	/**
	 * Set the coordinates of this point object.
	 *
	 * @param   x  The X-coordinate of the point in space. Will default to 0 if null.
	 * @param   y  The Y-coordinate of the point in space. Will default to `x` if null.
	 */
	public function set(?x:Float = 0.0, ?y:Float):FlxPoint {
		this.x = (x == null) ? 0.0 : x;
		this.y = (y == null) ? this.x : y;

		return this;
	}

	/**
	 * Adds to the coordinates of this point.
	 *
	 * @param   x  Amount to add to x.
	 * @param   y  Amount to add to y. Will default to `x` if null.
	 * @return  This point.
	 */
	public function add(x:Float, ?y:Float) {
		this.x += x;
		this.y += (y == null) ? x : y;

		return this;
	}

	@:op(A + B) public function addFloat(x:Float)
		return new FlxPoint(this.x + x, this.y + x);

	@:op(A + B) public function addPoint(p:IFlxPoint)
		return new FlxPoint(this.x + p.x, this.y + p.y);

	@:op(A += B) public function addEqualsFloat(x:Float)
		return add(x);

	@:op(A += B) public function addEqualsPoint(p:IFlxPoint)
		return add(p.x, p.y);

	/**
	 * Subtracts the coordinates of this point.
	 *
	 * @param   x  Amount to add to x.
	 * @param   y  Amount to add to y. Will default to `x` if null.
	 * @return  This point.
	 */
	public function subtract(x:Float, ?y:Float) {
		this.x -= x;
		this.y -= (y == null) ? x : y;

		return this;
	}

	@:op(A - B) public function subtractFloat(x:Float)
		return new FlxPoint(this.x - x, this.y - x);

	@:op(A - B) public function subtractPoint(p:IFlxPoint)
		return new FlxPoint(this.x - p.x, this.y - p.y);

	@:op(A -= B) public function subtractEqualsFloat(x:Float)
		return subtract(x);

	@:op(A -= B) public function subtractEqualsPoint(p:IFlxPoint)
		return subtract(p.x, p.y);

	/**
	 * Scales the coordinates of this point.
	 *
	 * @param   x  Amount to add to x.
	 * @param   y  Amount to add to y. Will default to `x` if null.
	 * @return  This point.
	 */
	public function scale(x:Float, ?y:Float) {
		this.x *= x;
		this.y *= (y == null) ? x : y;

		return this;
	}

	@:op(A * B) public function scaleFloat(x:Float)
		return new FlxPoint(this.x * x, this.y * x);

	@:op(A * B) public function scalePoint(p:IFlxPoint)
		return new FlxPoint(this.x * p.x, this.y * p.y);
	
	@:op(A *= B) public function scaleEqualsFloat(x:Float)
		return scale(x);

	@:op(A *= B) public function scaleEqualsPoint(p:IFlxPoint)
		return scale(p.x, p.y);

	/**
	 * Divides the coordinates of this point.
	 *
	 * @param   x  Amount to add to x.
	 * @param   y  Amount to add to y. Will default to `x` if null.
	 * @return  This point.
	 */
	public function divide(x:Float, ?y:Float) {
		this.x /= x;
		this.y /= (y == null) ? x : y;

		return this;
	}
	
	@:op(A / B) public function divideFloat(x:Float)
		return new FlxPoint(this.x / x, this.y / x);

	@:op(A / B) public function dividePoint(p:IFlxPoint)
		return new FlxPoint(this.x / p.x, this.y / p.y);

	@:op(A /= B) public function divideEqualsFloat(x:Float)
		return divide(x);

	@:op(A /= B) public function divideEqualsPoint(p:IFlxPoint)
		return divide(p.x, p.y);

	/**
	 * Helper function, just copies the values from the specified point.
	 *
	 * @param   p  Any FlxPoint.
	 * @return  A reference to itself.
	 */
	public function copyFrom(p:IFlxPoint) {
		set(p.x, p.y);
		return this;
	}
}

interface IFlxPoint {
	/**
	 * The X position of the point.
	 */
	public var x:Float;

	/**
	 * The Y position of the point.
	 */
	public var y:Float;

	public function set(?x:Float, ?y:Float):IFlxPoint;

	public function add(x:Float, ?y:Float):IFlxPoint;
	public function addFloat(x:Float):IFlxPoint;
	public function addPoint(p:IFlxPoint):IFlxPoint;
	
	public function addEqualsFloat(x:Float):IFlxPoint;
	public function addEqualsPoint(p:IFlxPoint):IFlxPoint;
	
	public function subtract(x:Float, ?y:Float):IFlxPoint;
	public function subtractFloat(x:Float):IFlxPoint;
	public function subtractPoint(p:IFlxPoint):IFlxPoint;
	
	public function subtractEqualsFloat(x:Float):IFlxPoint;
	public function subtractEqualsPoint(p:IFlxPoint):IFlxPoint;

	public function scale(x:Float, ?y:Float):IFlxPoint;
	public function scaleFloat(x:Float):IFlxPoint;
	public function scalePoint(p:IFlxPoint):IFlxPoint;

	public function scaleEqualsFloat(x:Float):IFlxPoint;
	public function scaleEqualsPoint(p:IFlxPoint):IFlxPoint;

	public function divide(x:Float, ?y:Float):IFlxPoint;
	public function divideFloat(x:Float):IFlxPoint;
	public function dividePoint(p:IFlxPoint):IFlxPoint;

	public function divideEqualsFloat(x:Float):IFlxPoint;
	public function divideEqualsPoint(p:IFlxPoint):IFlxPoint;

	public function copyFrom(p:IFlxPoint):IFlxPoint;
}