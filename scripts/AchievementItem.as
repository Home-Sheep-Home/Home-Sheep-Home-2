package
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public dynamic class AchievementItem extends MovieClip
   {
       
      
      public var txtTitle:TextField;
      
      public var locked:MovieClip;
      
      public var txtDescription:TextField;
      
      public var icon:MovieClip;
      
      public var newMarker:MovieClip;
      
      public function AchievementItem()
      {
         super();
         addFrameScript(0,this.frame1);
      }
      
      internal function frame1() : *
      {
         stop();
      }
   }
}
