package Talismania
{
	/**
	 * ...
	 * @author Skillcheese
	 */
	
	import flash.display.Bitmap;
	import flash.display.MovieClip;
	import flash.filesystem.*;
	import flash.system.*;
	import flash.events.*;
	import flash.filters.GlowFilter;
	import flash.net.*;
	import Talismania.TalismanFilter;
	import flash.geom.Point;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.text.ReturnKeyLabel;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	import flash.utils.ByteArray;

	// We extend MovieClip so that flash.display.Loader accepts our class
	// The loader also requires a parameterless constructor (AFAIK), so we also have a .Bind method to bind our class to the game
	public class Talismania extends MovieClip
	{
		public const VERSION:String = "1.0";
		public const GAME_VERSION:String = "1.0.21";
		public const BEZEL_VERSION:String = "0.1.0";
		public const MOD_NAME:String = "Talismania";
		
		private var gameObjects:Object;
		
		// Game object shortcuts
		private var core:Object;/*IngameCore*/
		private var cnt:Object;/*CntIngame*/
		public var GV:Object;/*GV*/
		public var SB:Object;/*SB*/
		public var prefs:Object;/*Prefs*/
		
		// Mod loader object
		internal static var bezel:Object;
		
		internal static var logger:Object;
		internal static var storage:File;

		private var configuration:Object;
		private var defaultHotkeys:Object;
		private var infoPanelState:int;
		private var activeBitmaps:Object;
		
		private var automaters:Array = new Array();
		private var automatersEnabled:Boolean = false;
		private var renderingAutomaters:Boolean = false;
		private var automaterDelay:int = 125;
		private var automatersIndex:int = 0;
		private var checkedTalismans:Array = new Array();
		private var checkingTalismans:Boolean = false;
		private var replaceMode:Boolean = false;
		private var talismanRune:int = -1;
		private var filterCost:int = 50000;
		private var randomCost:int = 1000;
		
		// Parameterless constructor for flash.display.Loader
		public function Talismania()
		{
			super();
		}
		
		// This method binds the class to the game's objects
		public function bind(modLoader:Object, gameObjects:Object) : Talismania
		{
			bezel = modLoader;
			logger = bezel.getLogger("Talismania");
			storage = File.applicationStorageDirectory;
			this.gameObjects = gameObjects;
			this.core = gameObjects.GV.ingameCore;
			this.cnt = gameObjects.GV.main.cntScreens.cntIngame;
			this.SB = gameObjects.SB;
			this.GV = gameObjects.GV;
			this.prefs = gameObjects.prefs;
			
			prepareFoldersAndLogger();
			
			addEventListeners();
			
			logger.log("Talismania", "Talismania initialized!");
			checkTalismanDrops();
			return this;
		}

		public function showMessage(message:String) :void
		{
			GV.vfxEngine.createFloatingText4(GV.main.mouseX, GV.main.mouseY < 60?Number(GV.main.mouseY + 30):Number(GV.main.mouseY - 20), message, 16768392, 12, "center", Math.random() * 3 - 1.5, -4 - Math.random() * 3, 0, 0.55, 12, 0, 1000);
		}
		
		public function checkTalismanDrops(): void
		{
			for (var i:int = 0; i < core.ocLootTalFrags.length; i++)
			{
				var item:Object = core.ocLootTalFrags[i];
				if (checkedTalismans.indexOf(item) == -1)
				{
					logger.log("", "" + item.seed);
					var enrageGem:Object = core.gemInEnragingSlot;
					var rarity:Number = item.rarity.g();
					if (enrageGem != null)
					{
						rarity += enrageGem.grade.g() * 1.5;
					}
					if (rarity > 100)
					{
						rarity = 100;
					}
					item.rarity.s(rarity);
					item.calculateProperties();
					checkedTalismans.push(item);
				}
			}
			var timer:Timer = new Timer(100, 1);
			var func:Function = function(e:Event): void {checkTalismanDrops(); };
			timer.addEventListener(TimerEvent.TIMER, func);
			timer.start();
		}
		
		private function prepareFoldersAndLogger(): void
		{
			var storageFolder:File = storage.resolvePath("Talismania");
			if (!storageFolder.isDirectory)
			{
				logger.log("PrepareFolders", "Creating ./Talismania");
				storageFolder.createDirectory();
			}

			var fwgc:File = storage.resolvePath("FWGC");
			if(!fwgc.isDirectory)
				return;

			logger.log("PrepareFolders", "Moving stuff from ./FWGC");
			var oldConfig:File = storage.resolvePath("FWGC/FWGC_config.json");
			
			fwgc.moveToTrash();
			logger.log("PrepareFolders", "Moved ./FWGC to trash!");
		}
		
		public function prettyVersion(): String
		{
			return 'v' + VERSION + ' for ' + GAME_VERSION;
		}
		
		private function addEventListeners(): void
		{
			GV.main.stage.addEventListener(KeyboardEvent.KEY_DOWN, ehKeyboardInStageMenu, false, 0, true);
		}
		
		private function ehKeyboardInStageMenu(pE:KeyboardEvent): void
		{
			if (pE.keyCode == 33) //page up
			{
				
			}
			if (pE.keyCode == 34) // page down
			{
				
			}
			if (pE.keyCode == 75) // k
			{
				if (GV.selectorCore.screenStatus == 205 || GV.selectorCore.screenStatus == 206) // if we're in the talisman menu
				{
					var filter:TalismanFilter;
					if (pE.altKey)
					{
						filter = new TalismanFilter(TalismanFilter.myFilterInner, TalismanFilter.myFilterEdge, TalismanFilter.myFilterCorner, Math.random() * 7999998, 3);
						filterTalisman(filter);
					}
					else
					{
						filter = new TalismanFilter([TalismanFilter.SKILLS_ALL], [TalismanFilter.SKILLS_ALL], [TalismanFilter.SKILLS_ALL], Math.random() * 7999998);
						filterTalisman(filter, true);
					}
				}
			}
		}
		
		public function filterTalisman(filter:TalismanFilter, costOverride:Boolean = false): void
		{
			var cost:int = costOverride ? randomCost : filterCost;
			if (GV.selectorCore.screenStatus != 205 && GV.selectorCore.screenStatus != 206) // if we're in the talisman menu
			{
				return;
			}
			var talFrag:Object = getMouseTalisman();
			if (talFrag == null) //if we are over a talisman
			{
				return;
			}
			if (talFrag.rarity.g() < 100)
			{
				showMessage("Fragment must be rarity 100!");
				return;
			}
			if (GV.ppd.shadowCoreAmount.g() < cost)
			{
				var costBeginning:int = Math.round(cost / 1000);
				showMessage("Not enough shadow cores, requires " + costBeginning + ",000!");
				return;
			}
			var time:int = getTimer();
			var frag:Object = filter.getTalismanMatchingFilter(talFrag.clone());
			if (frag != null)
			{
				var numSeeds:int = frag.seed - TalismanFilter.talismanSeedBase - filter.startSeed;
				var elapsedTime:Number = (getTimer() - time + 1) / 1000;
				logger.log("", "Number of seeds searched: " + numSeeds);
				logger.log("", "Elapsed Time: " + elapsedTime);
				logger.log("", "seeds/s: " + (numSeeds / elapsedTime));
				talFrag.seed = frag.seed;
				talFrag.calculateProperties();
				talFrag.hasChangedShape = true;
				GV.selectorCore.pnlTalisman.dirtyFlag = true;
				GV.talFragBitmapCreator.giveTalFragBitmaps(talFrag);
				
				GV.ppd.shadowCoreAmount.s(GV.ppd.shadowCoreAmount.g() - cost);
				GV.selectorCore.renderer.updateShadowCoreCounter(GV.ppd.shadowCoreAmount.g());
				
				showMessage("Talismania Completed Successfully!");
			}
			else
			{
				showMessage("Fragment search failed!");
			}
		}
		
		private function getMouseTalisman(): Object
		{
			var vMx:Number = GV.selectorCore.pnlTalisman.mc.root.mouseX;//find talisman or null
			var vMy:Number = GV.selectorCore.pnlTalisman.mc.root.mouseY;
			var pSlotNum:int = -1;
			var location:int = -1;
			if(vMx > 1180 && vMx < 1180 + 6 * 106 && vMy > 170 && vMy < 170 + 6 * 106)
			{
				pSlotNum = 6 * Math.floor((vMy - 170) / 106) + Math.floor((vMx - 1180) / 106); // inventory
				location = 1;
			}
			else if(vMx > 106 && vMx < 106 + 5 * 183 && vMy > 98 && vMy < 98 + 5 * 160) // talisman slots
			{
				pSlotNum = 5 * Math.floor((vMy - 98) / 160) + Math.floor((vMx - 106) / 183);
				location = 2;
			}
			var talFrag:Object = null;
			switch(location)
			{
				case -1:
					break;
				case 1:
					talFrag = GV.ppd.talismanInventory[pSlotNum];
					break;
				case 2:
					talFrag = null;
					showMessage("you cannot edit fragments in the talisman");
					break;
			}
			return talFrag;
		}
		
		public function unload(): void
		{
			removeEventListeners();
			bezel = null;
			logger = null;
		}
		
		private function removeEventListeners(): void
		{
			GV.main.stage.removeEventListener(KeyboardEvent.KEY_DOWN, ehKeyboardInStageMenu, false);
		}
	}
}