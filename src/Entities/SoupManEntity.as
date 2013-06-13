package Entities 
{
	import net.flashpunk.Entity;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	/**
	 * ...
	 * @author Nick Pettyjohn
	 */
	public class SoupManEntity extends Entity
	{
		
		[Embed(source = '../../assets/art/soup_man.png')] private const SOUPMANGRAPHIC:Class;
		
		public var doorIndex:int;
		public var offsetX:int = 25;
		public var offsetY:int = 30;
		private var targetX:int;
		private var targetY:int;
		private var speed:Number = 50;
		
		private var isMoving:Boolean = false;
		
		public function SoupManEntity() 
		{
			graphic = new Image(SOUPMANGRAPHIC);
			Image(graphic).scale = 2;
			Image(graphic).centerOrigin();
		}
		
		override public function update():void 
		{
			if (isMoving) {
				moveTowards(targetX, targetY, speed);
				if (super.x == targetX && super.y == targetY)
					isMoving = false;
			}
			super.update();
		}
		
		public function MoveLeft(doors:Array):void {
			if(!isMoving) {
				doorIndex--;
				if (doorIndex < 0) doorIndex = 0;
				
				targetX = doors[doorIndex].x - offsetX;
				targetY = doors[doorIndex].y - offsetY;
				isMoving = true;
			}
			//super.x = doors[doorIndex].x - offsetX;
			//super.y = doors[doorIndex].y - offsetY;
		}
		
		public function MoveRight(doors:Array):void {
			if(!isMoving) {
				doorIndex++;
				if (doorIndex > doors.length -1) doorIndex = doors.length -1;
				
				targetX = doors[doorIndex].x - offsetX;
				targetY = doors[doorIndex].y - offsetY;
				isMoving = true;
			}
			
			//super.x = doors[doorIndex].x - offsetX;
			//super.y = doors[doorIndex].y - offsetY;
		}
		
		public function ToggleDoor(doors:Array):void {
			if(!isMoving) {
				DoorEntity(doors[doorIndex]).Toggle();
			}
		}
	}

}