package flixel;

import flixel.math.FlxPoint;

// just putting this here so we don't have to make it later ig
/**
 * The core building blocks of all Flixel games. With helpful tools for animation, movement and
 * features for the needs of most games.
 * 
 * It is pretty common place to extend `FlxSprite` for your own game's needs; for example a `SpaceShip`
 * class may extend `FlxSprite` but could have additional variables for the game like `shieldStrength`
 * or `shieldPower`.
 */
class FlxSprite extends FlxObject {
	/**
	 * The position of the sprite's graphic relative to its hitbox. For example, `offset.x = 10;` will
	 * show the graphic 10 pixels left of the hitbox. Likely needs to be adjusted after changing a sprite's
	 * `width`, `height` or `scale`.
	 */
	public var offset(default, set):FlxPoint = new FlxPoint();

	/**
	 * Change the size of your sprite's graphic.
	 * NOTE: The hitbox is not automatically adjusted, use `updateHitbox()` for that.
	 * 
	 * @see https://snippets.haxeflixel.com/sprites/scale/
	 */
	public var scale(default, set):FlxPoint = new FlxPoint().copyFrom(FlxPoint.ONE);

	// [ PRIVATE ] //

	// Doing this to prevent the GC from blowing up
	@:noCompletion
	private function set_offset(newOffset:FlxPoint) {
		return offset.copyFrom(newOffset);
	}

	@:noCompletion
	private function set_scale(newScale:FlxPoint) {
		return offset.copyFrom(newScale);
	}
}