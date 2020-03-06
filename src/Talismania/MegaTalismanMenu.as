package Talismania 
{
	/**
	 * ...
	 * @author Skillcheese
	 */
	import flash.display.MovieClip;
	import flash.display.Sprite;
	
	public class MegaTalismanMenu extends Sprite
	{
		public var test:MovieClip;
		public var cnt:SpriteExt;
		public var mc:SpriteExt;
		
		public function MegaTalismanMenu() 
		{
			super();
			mc = new SpriteExt();
			mc.mouseEnabled = false;
			mc.mouseChildren = false;
		}
		
	}

}