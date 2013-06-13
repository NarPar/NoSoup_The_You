package 
{
	import flash.display.Sprite;
	import flash.events.Event;
	import net.flashpunk.Engine;
	import net.flashpunk.FP;
	
	/**
	 * ...
	 * @author Nick Pettyjohn
	 */
	public class Main extends Engine
	{
		
		public function Main():void 
		{
			super(800, 600, 60, false);
			FP.world = new HoardTheSoupWorld();
		}
		
		override public function init():void
		{
			trace("FlashPunk has started successfully!");
		}
		
	}
	
}