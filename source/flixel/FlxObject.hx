package flixel;

import flixel.math.FlxPoint;

/**
 * A simple game object with positional and sizing values.
 */
class FlxObject extends FlxBasic {
	/**
	 * X position of the upper left corner of this object in world space.
	 */
    public var x:Float = 0;

	/**
	 * Y position of the upper left corner of this object in world space.
	 */
    public var y:Float = 0;

	/**
	 * The width of this object's hitbox. For sprites, use `offset` to control the hitbox position.
	 */
    public var width:Float = 0;

	/**
	 * The height of this object's hitbox. For sprites, use `offset` to control the hitbox position.
	 */
    public var height:Float = 0;

    /**
     * The speed in which the object will move per second.
     */
    public var velocity:FlxPoint = new FlxPoint();

    /**
     * Caps off the `velocity` variable to ensure that `acceleration` does not set the `velocity` extremely high.
     */
    public var maxVelocity:FlxPoint = new FlxPoint(10000, 10000);

    /**
     * An additional variable that adds itself to `velocity` every frame.
     */
    public var acceleration:FlxPoint = new FlxPoint();

    /**
     * An additional variable that lerps `acceleration` to back to 0.
     */
    public var drag:FlxPoint = new FlxPoint();
}