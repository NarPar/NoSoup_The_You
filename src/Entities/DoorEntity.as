package Entities 
{
	import flash.geom.Rectangle;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	/**
	 * ...
	 * @author Nick Pettyjohn
	 */
	public class DoorEntity extends Collidable_Entity
	{
		[Embed(source = '../../assets/art/door.png')] private const DOORGRAPHIC:Class;
		
		private var Width:int = 50;
		private var Height:int = 50;
		public var isOpen:Boolean;
		
		public function DoorEntity(x:int,y:int) 
		{
			super(x, y, Width, Height, false);
			graphic = new Image(DOORGRAPHIC);
			Image(graphic).scale = 3.0;
		}
		
		public function Toggle():void {
			if (isOpen) 
				Close();
			else 
				Open();
		}
		
		public function Open():void {
			Image(graphic).angle = 90.0;
			isOpen = true;
		}
		
		public function Close():void {
			Image(graphic).angle = 0.0;
			isOpen = false;
		}
		
	}

}