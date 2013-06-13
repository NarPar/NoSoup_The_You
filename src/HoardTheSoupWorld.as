package  
{
	import adobe.utils.CustomActions;
	import Entities.Collidable_Entity;
	import Entities.DoorEntity;
	import Entities.KidEntity;
	import Entities.SoupEntity;
	import Entities.SoupManEntity;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.Sfx;
	import net.flashpunk.World;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import net.flashpunk.FP;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.Graphic;
	/**
	 * ...
	 * @author Nick Pettyjohn
	 */
	public class HoardTheSoupWorld extends World
	{
		[Embed(source = '../assets/art/background.png')] private const BACKGROUND:Class;
		[Embed(source = '../assets/art/wall.png')] private const WALLGRAPHIC:Class;
		[Embed(source = '../assets/art/footprint.png')] private const FOOTPRINTGRAPHIC:Class;
		
		private var bg:Entity;
		private var wall:Entity;
		private var doors:Array = new Array();
		private var soupMan:SoupManEntity;
		private var soup:SoupEntity;
		private var kids:Array = new Array();
		private var footprints:Array = new Array();
		
		private var doorOpenTimer:Number = 0.0;
		private var openTime:Number = 0.0;
		private var time:Number = 0.0;
		
		private var score:Number = 0.0;
		private var scoreEntity:Entity;
		
		private var soupHP:int = 20;
		private var soupHPEntity:Entity;
		
		private var highscore:int = 0;
		private var highscoreEntity:Entity;
		
		private var promptEntity:Entity;
		
		private var state:int = 0;
		
		public function HoardTheSoupWorld()
		{

			
			var g:Graphic;
			g = new Image(BACKGROUND);
			bg = new Entity(0,0, g);
			add(bg);
			
			g = new Image(WALLGRAPHIC);
			Image(g).scaleX = 160.0;
			Image(g).scaleY = 5;
			Image(g).centerOrigin();
			wall = new Entity(FP.halfWidth, FP.height / 3.5, g);
			wall.layer = -1;
			add(wall);
			
			for (var i:int = 1; i <= 7; i++) {
				var d:DoorEntity = new DoorEntity( i * FP.width / 8, FP.height / 3.5);
				d.layer = -2;
				doors.push(d);
				add(d);
			}
			
			soupMan = new SoupManEntity();
			add(soupMan);
			soupMan.MoveRight(doors);
			
			soup = new SoupEntity(FP.halfWidth, FP.height / 8);
			add(soup);
			
			OpenRandomDoors();
			
			var t:Text = new Text(("Score = " + score));
			t.color = 0xFFFFFF;
			t.size = 20;
			scoreEntity = new Entity(50,50,t);
			add(scoreEntity);
			
			t = new Text(("Soup = " + soupHP));
			t.color = 0xFFFFFF;
			t.size = 20;
			soupHPEntity = new Entity(FP.halfWidth, 50, t);
			add(soupHPEntity);
			
			t= new Text(("High Score = " + highscore));
			t.color = 0xFFFFFF;
			t.size = 20;
			highscoreEntity = new Entity(50,75,t);
			add(highscoreEntity);
			
			t= new Text(("NO SOUP FOR YOU!\n\n\n<Press Space to Restart>"));
			t.color = 0xFFFFFF;
			t.size = 20;
			promptEntity = new Entity(FP.halfWidth- 200,FP.halfHeight-200,t);
		}
		
		override public function update():void {
			
			switch(state) {
				case(0): // playing
					if(Input.pressed(Key.SPACE)) {
						soupMan.ToggleDoor(doors);
					}
					if(Input.pressed(Key.LEFT)) {
						soupMan.MoveLeft(doors);
					}
					if(Input.pressed(Key.RIGHT)) {
						soupMan.MoveRight(doors);
					}
					
					UpdateTimers();
					
					IncrementScore(FP.elapsed);
					
					super.update();
					break;
				case(1): // End
					if(Input.pressed(Key.SPACE)) {
						Restart();
					}
					break;
			
			
			
			
			}
		}
		
		public function IncrementScore(val:Number):void {
			score += val;
			Text(scoreEntity.graphic).text = "Score = " + int(score);
		}
		
		public function DamageSoup(val:int):void {
			soupHP -= val;
			Text(soupHPEntity.graphic).text = "Soup = " + soupHP;
			if (soupHP <= 0)
				GameOver();
		}
		
		public function Restart():void {
			state = 0;
			score = 0;
			Text(scoreEntity.graphic).text = "Score = " + int(score);
			soupHP = 20;
			Text(soupHPEntity.graphic).text = "Soup = " + soupHP;
			for (var i:int = 0; i < doors.length; i++) {
				DoorEntity(doors[i]).Close();
			}
			
			for (var j:int = 0; j < kids.length; j++) {
				kids.pop();
			}
			
			time = 0;
			doorOpenTimer = 0;
			remove(promptEntity);
		}
		
		public function GameOver():void {
			state = 1;
			if (score > highscore) highscore = score;
			add(promptEntity);
		}
		
		private function UpdateTimers():void {
			time += FP.elapsed;
			doorOpenTimer += FP.elapsed;
			
			if (doorOpenTimer >= openTime) {
				OpenRandomDoors();
			}
		}
		
		private function GetDifficulty():Number {
			var diff:Number = Math.min(4.0,time / 30.0);
			trace("Difficulty = " + diff );
			return diff;
		}
		
		private function OpenRandomDoors():void {
			var indexes:Array = new Array();
			indexes.push(0);
			indexes.push(1);
			indexes.push(2);
			indexes.push(3);
			indexes.push(4);
			
			var num:int = Math.max(3,FP.rand(Math.min(7,int(10 * GetDifficulty()))));
			for (var i:int = 0; i < num; i++) {
				DoorEntity(doors[FP.rand(7)]).Open();
			}
			trace("Opened " + num + " doors.");
			
			//reset timer
			doorOpenTimer = 0.0;
			openTime = 4.0 - GetDifficulty();
			trace("OpenTime set to " + openTime );
			
			SpawnKids();
		}
		
		private function SpawnKids():void {
			var spawnX:int = FP.halfWidth;
			var spawnY:int = FP.height / 1.5;
			
			var num:int = Math.min(2, FP.rand(Math.max(5, int(6 * GetDifficulty()))));
			for (var i:int = 0; i < num; i++) {
				
				var offsetX:int = FP.random * 100;
				var n:int = FP.rand(2);
				if (n) offsetX *= -1;
				var offsetY:int = FP.random * 100;
				n = FP.rand(2);
				if (n) offsetY *= -1;
				
				var kid:KidEntity = new KidEntity(spawnX, spawnY, doors, soup);
				kids.push(kid);
				add(kid);
			}
		}
		
		public function CreateFootprint(x:int, y:int) {
			var g:Image = new Image(FOOTPRINTGRAPHIC);
			g.centerOrigin();
			var f:Entity = new Entity(x, y, g)
			footprints.push(f);
			add(f);
			
			
			if (footprints.length > 30) {
				remove(footprints[0]);
				footprints.shift();
			}
		}
	}

}