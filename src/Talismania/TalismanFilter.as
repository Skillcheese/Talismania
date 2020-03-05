package Talismania 
{
	/**
	 * ...
	 * @author Skillcheese
	 */
	
	 import Talismania.PRandom;
	public class TalismanFilter 
	{
		public static var numTalismans:int = 8999998;
		public static var talismanSeedBase:int = 1000000;
		public static var maxTalismanSeed:int = 1000000 + 8999998;
		public var forceRune:int = -1;
		private var idsInner:Array;
		private var idsCorner:Array;
		private var idsEdge:Array;
		
		public static var worthless:Array = [
		DAMAGE_TO_FLYING,
		BEAM_DAMAGE,
		BOLT_DAMAGE,
		BARRAGE_DAMAGE,
		MANA_FOR_EARLY_WAVES,
		WHITEOUT_POISONBOOST_PCT,
		DAMAGE_TO_BUILDINGS,
		HEAVIER_ORBLETS,
		FASTER_ORBLET_ROLLBACK,
		MANA_SHARD_HARVESTING_SPEED,
		FREEZE_ARMOR_PCT,
		FREEZE_CORPSE_EXPLOSION_HP_PCT,
		GEM_BOMB_EXTRA_WASP_CHANCE,
		WASPS_FASTER_ATTACK,
		ICESHARDS_BLEEDING_PCT,
		ICESHARDS_SLOWINGDUR_PCT,
		FREEZE_DURATION,
		ICESHARDS_HEALTH_LOSS,
		ICESHARDS_HPLOSS_PCT,
		ICESHARDS_ARMORLOSS_PCT
		];
		
		public static var bestFilter:Array = [
		DAMAGE_TO_SWARMLINGS,
		DAMAGE_TO_REAVERS,
		DAMAGE_TO_GIANTS,
		XP_GAINED,
		WHITEOUT_XPBOOST_PCT,
		WHITEOUT_MANALEECHBOOST_PCT,
		WHITEOUT_DURATION,
		MAX_WHITEOUT_CHARGE
		];
		
		public static var myFilterCorner:Array = [
		XP_GAINED,
		WHITEOUT_XPBOOST_PCT,
		WHITEOUT_MANALEECHBOOST_PCT,
		FREEZE_DURATION,
		ICESHARDS_HPLOSS_PCT
		];
		
		public static var myFilterEdge:Array = [
		XP_GAINED,
		DAMAGE_TO_FLYING,
		WIZLEVEL_TO_XP_AND_MANA,
		DAMAGE_TO_SWARMLINGS,
		DAMAGE_TO_REAVERS,
		DAMAGE_TO_GIANTS
		];
		
		public static var myFilterInner:Array = [
		XP_GAINED,
		WIZLEVEL_TO_XP_AND_MANA,
		WHITEOUT_XPBOOST_PCT,
		DAMAGE_TO_SWARMLINGS,
		DAMAGE_TO_REAVERS,
		DAMAGE_TO_GIANTS
		];
		
		public function TalismanFilter(inner:Array = null, edge:Array = null, corner:Array = null,runeId:int = -1) 
		{
			if (inner == null || edge == null || corner == null)
			{
				idsInner = new Array();
				idsEdge = new Array();
				idsCorner = new Array();
			}
			else
			{
				idsInner = inner;
				idsEdge = edge;
				idsCorner = corner;
			}
			forceRune = runeId;
		}
		
		public function getTalismanMatchingFilter(talismanBase:Object): Object
		{
			if (talismanBase.rarity.g() < 100)
			{
				return null;
			}
			var start:int = 1000000 + ((talismanBase.seed - 1000000) * 187 + 903953) % 8999998;
			var end:int = maxTalismanSeed;
			var passTest:Boolean = true;
			var ids:Array;
			switch(talismanBase.type)
			{
				case INNER:
					ids = idsInner;
					break;
				case EDGE:
					ids = idsEdge;
					break;
				case CORNER:
					ids = idsCorner;
					break;
			}
			for (var i:int = start; i < end; i++)
			{
				if (forceRune != -1)
				{
					var prn:PRandom = new PRandom();
					prn.setSeed(i);
					var rune:int = Math.floor(prn.getRnd() * 9.99);
					if (rune >= 5)
					{
						continue;
					}
				}
				
				var talCurrent:Object = getTalisman(talismanBase, i);
				passTest = true;
				
				for each (var id:int in ids)
				{
					if (!doesTalismanContainId(talCurrent, id))
					{
						passTest = false;
						break;
					}
				}
				if (passTest)
				{
					return talCurrent;
				}
			}
			return null;
		}
		
		public function doesTalismanContainId(talisman:Object, id:int): Boolean
		{
			return talisman.propertyIds.indexOf(id) != -1;
		}
		
		public function getTalisman(talisman:Object, seed:int): Object
		{
			talisman.seed = seed;
			talisman.calculateProperties();
			return talisman;
		}
		
	  public static var vInnerPropertyIds:Array = [7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 28, 38, 29, 30, 31, 32, 33, 34, 35, 36, 37, 40];
      public static var vEdgePropertyIds:Array = [7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 21, 22, 23, 24, 25, 26, 27, 28, 31, 32, 33, 35, 37, 38];
	  public static var vCornerPropertyIds:Array = [7, 8, 9, 10, 11, 12, 13, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 34, 38, 39, 40, 41, 42, 43, 44];
	  public static var EDGE:int = 0;
	  public static var CORNER:int = 1;
	  public static var INNER:int = 2;
		
	  public static var SKILLS_CONSTRUCTION:int = 0;
      
      public static var SKILLS_COMPONENT:int = 1;
      
      public static var SKILLS_FOCUS:int = 2;
      
      public static var SKILLS_ENHANCEMENT:int = 3;
      
      public static var SKILLS_STRIKE_SPELLS:int = 4;
      
      public static var SKILLS_WRATH:int = 5;
      
      public static var SKILLS_ALL:int = 6;
      
      public static var DAMAGE_TO_SWARMLINGS:int = 7;
      
      public static var DAMAGE_TO_REAVERS:int = 8;
      
      public static var DAMAGE_TO_GIANTS:int = 9;
      
      public static var XP_GAINED:int = 10;
      
      public static var WIZLEVEL_TO_XP_AND_MANA:int = 11;
      
      public static var INITIAL_MANA:int = 12;
      
      public static var DAMAGE_TO_FLYING:int = 13;
      
      public static var BEAM_DAMAGE:int = 15;
      
      public static var BOLT_DAMAGE:int = 16;
      
      public static var BARRAGE_DAMAGE:int = 17;
      
      public static var MANA_FOR_EARLY_WAVES:int = 28;
      
      public static var WHITEOUT_POISONBOOST_PCT:int = 38;
      
      public static var DAMAGE_TO_BUILDINGS:int = 14;
      
      public static var HEAVIER_ORBLETS:int = 31;
      
      public static var FASTER_ORBLET_ROLLBACK:int = 32;
      
      public static var MANA_SHARD_HARVESTING_SPEED:int = 33;
      
      public static var FREEZE_ARMOR_PCT:int = 35;
      
      public static var FREEZE_CRITHITDMG_PCT:int = 36;
      
      public static var FREEZE_CORPSE_EXPLOSION_HP_PCT:int = 37;
      
      public static var GEM_BOMB_EXTRA_WASP_CHANCE:int = 29;
      
      public static var SLOWER_KILLCHAIN_COOLDOWN:int = 30;
      
      public static var WASPS_FASTER_ATTACK:int = 34;
      
      public static var WHITEOUT_MANALEECHBOOST_PCT:int = 39;
      
      public static var WHITEOUT_XPBOOST_PCT:int = 40;
      
      public static var ICESHARDS_BLEEDING_PCT:int = 43;
      
      public static var ICESHARDS_SLOWINGDUR_PCT:int = 44;
      
      public static var FREEZE_DURATION:int = 18;
      
      public static var WHITEOUT_DURATION:int = 19;
      
      public static var ICESHARDS_HEALTH_LOSS:int = 20;
      
      public static var MAX_FREEZE_CHARGE:int = 21;
      
      public static var MAX_WHITEOUT_CHARGE:int = 22;
      
      public static var MAX_ICESHARDS_CHARGE:int = 23;
      
      public static var MAX_BOLT_CHARGE:int = 24;
      
      public static var MAX_BEAM_CHARGE:int = 25;
      
      public static var MAX_BARRAGE_CHARGE:int = 26;
      
      public static var MAX_SHRINE_CHARGE:int = 27;
      
      public static var ICESHARDS_HPLOSS_PCT:int = 41;
      
      public static var ICESHARDS_ARMORLOSS_PCT:int = 42;
	}

}