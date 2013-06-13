package Entities 
{
	
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	/**
	 * ...
	 * @author Nick Pettyjohn
	 */
	public class SoupEntity extends Collidable_Entity
	{
		[Embed(source = '../../assets/art/soup.png')] private const SOUPGRAPHIC:Class;
		
		private var Width:int = 20;
		private var Height:int = 20;
		public function SoupEntity(x:int,y:int) 
		{
			super(x, y, Width, Height, true);
			graphic = new Image(SOUPGRAPHIC);
			Image(graphic).scale = 3.0;
		}
		
		
		
	}

}