package
{
   import flash.display.MovieClip;
   import flash.text.TextField;
   
   public dynamic class ProjectorScreenGfx extends MovieClip
   {
       
      
      public var CreditsDCUnlocked:TextField;
      
      public var CreditsToRead:TextField;
      
      public var commentaryIcon:MovieClip;
      
      public var noExport:MovieClip;
      
      public function ProjectorScreenGfx()
      {
         super();
         addFrameScript(0,this.frame1,10,this.frame11);
      }
      
      internal function frame1() : *
      {
         stop();
      }
      
      internal function frame11() : *
      {
         stop();
      }
   }
}
