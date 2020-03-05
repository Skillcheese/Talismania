package Talismania 
{
	/**
	 * ...
	 * @author Skillcheese
	 */
	public class MegaTalisman 
	{
		public static var WHITEOUT_MANA_LEECH_ID:int = 1;
		public static var POISON_MEGABOOST:int = 2;
		public static var LANTERN_SPECIALS_BOOST:int = 3;
		
		public var properties:Array = new Array();
		
		public function MegaTalisman() 
		{
			this.properties[WHITEOUT_MANA_LEECH_ID] = 0;
			this.properties[POISON_MEGABOOST] = 0;
			this.properties[LANTERN_SPECIALS_BOOST] = 0;
		}
		
		public function loadMegaTalisman(data:String): void
		{
			if (data == "Loading Failed")
			{
				return;
			}
			var dataArray:Array = data.split("\n");
			for each (var string:String in dataArray)
			{
				if (string == "")
				{
					return;
				}
				var stringSplit:Array = string.split("/");
				if (stringSplit[0] == null || stringSplit[1] == null || stringSplit[0] == undefined || stringSplit[1] == undefined)
				{
					continue;
				}
				this. properties[int(stringSplit[0])] = int(stringSplit[1]);
			}
		}
		
		public function saveMegaTalisman(): String
		{
			var r:String = "";
			r += getMegaPropertyString(WHITEOUT_MANA_LEECH_ID);
			r += getMegaPropertyString(POISON_MEGABOOST);
			r += getMegaPropertyString(LANTERN_SPECIALS_BOOST);
			return r;
		}
		
		public function getMegaPropertyString(id:int): String
		{
			if (this.properties[id] == undefined)
			{
				return "";
			}
			return id + "/" + this.properties[id] + "\n";
		}
	}

}