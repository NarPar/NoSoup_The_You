package Entities 
{
	import flash.geom.Rectangle;
	import net.flashpunk.Entity;
	/**
	 * ...
	 * @author Nick Pettyjohn
	 */
	public class Collidable_Entity extends Entity
	{
		private var bounds:Rectangle;
		protected var passable:Boolean;
		public function Collidable_Entity(x:int, y:int, width:int, height:int, pass:Boolean) 
		{
			super(x, y);
			bounds = new Rectangle(x, y, width, height);
			passable = pass;
		}
		
		public function Collides( c:Collidable_Entity ) : Boolean {
			if (passable && bounds.intersects(c.bounds))
				return true;
			else
				return false;
		}
		
	}

}