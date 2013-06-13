package Entities 
{
	
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.FP;
	
	/**
	 * ...
	 * @author Nick Pettyjohn
	 */
	public class KidEntity extends Collidable_Entity
	{
		[Embed(source = '../../assets/art/little_kid.png')] private const LITTLEKIDGRAPHIC:Class;
		
		
		private var Width:int = 50;
		private var Height:int = 50;
		private var Speed:int = 5;
		private var isFocused:Boolean = false;
		private var targetX:int;
		private var targetY:int;
		private var isGettingSoup:Boolean;
		private var fDoor:DoorEntity;
		
		private var homeX:int;
		private var homeY:int;
		
		private var doors:Array
		private var soup:Entity;
		private var footprintTimer:Number = 2.0;
		private var leftFoot:Boolean = false;
		
		private var state:int; // 0 = idle, 1 = going to door, 2 = going to soup, 3 = going home, 4 = sit down
		
		public function KidEntity(x:int, y:int, doorses:Array, s:Entity) 
		{
			super(x, y, Width, Height, true);
			graphic = new Image(LITTLEKIDGRAPHIC);
			Image(graphic).scale = 3.0;
			
			homeX = x;
			homeY = y;
			
			doors = doorses;
			soup = s;
			state = 0;
		}
		
		override public function update():void 
		{
			RandomShuffle();
			
			switch(state) {
				
				case(0):
					CheckForOpenDoors();
					break;
				case(1):
					MoveToDoor();
					break;
				case(2):
					MoveToSoup();
					break;
				case(3):
					MoveToHome();
					CheckForOpenDoors();
					break;
				case(4):
					MoveToInside();
					break;
			}
			
			footprintTimer--;
			if (footprintTimer <= 0)
				MakeFootprint();
				
			super.update();
		}
		
		private function MakeFootprint():void {
			footprintTimer = 2.0;
			HoardTheSoupWorld(world).CreateFootprint(x, y);
		}
		
		private function MoveToDoor():void {
			moveTowards(fDoor.x, fDoor.y, Speed);
			if (!fDoor.isOpen) {
				state = 3;
			} else if (x == fDoor.x && y == fDoor.y)
				state = 2;
		}
		
		private function MoveToSoup():void {
			moveTowards(soup.x, soup.y, Speed);
			if (x == soup.x && y == soup.y) {
				// eat soup
				HoardTheSoupWorld(world).DamageSoup(1);
				state = 4;
			}
		}
		
		private function MoveToHome():void {
			moveTowards(homeX, homeY, Speed);
			if (x == homeX && y == homeY)
				state = 0;
		}
		
		private function MoveToInside():void {
			moveTowards(FP.halfWidth, -100, Speed);
			delete(this);
		}
		
		private function CheckForOpenDoors():void {
			for (var i:int = 0; i < doors.length; i++) {
				if (DoorEntity(doors[i]).isOpen) {
					FocusDoor(DoorEntity(doors[i]));
				}
			}
		}
	
		private function FocusDoor(d:DoorEntity) {
			state = 1;
			fDoor = d;
			//isFocused = true;
			targetX = d.x;
			targetY = d.y;
		}
		
		private function RandomShuffle():void {
			var n:int = FP.rand(2);
			if (n) 
				x -= Speed;
			else 
				x += Speed;
			n = FP.rand(2);
			if (n) 
				y -= Speed;
			else
				y += Speed;
		}
		}
	


}