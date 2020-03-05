package Talismania
{
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   
   public class SpriteExt extends Sprite
   {
       
      public function SpriteExt()
      {
         super();
      }
      
      override public function removeChild(pChild:DisplayObject) : DisplayObject
      {
         if(pChild != null && this.contains(pChild))
         {
            return super.removeChild(pChild);
         }
         return null;
      }
      
      override public function removeChildAt(pNum:int) : DisplayObject
      {
         return super.removeChildAt(pNum);
      }
   }
}
