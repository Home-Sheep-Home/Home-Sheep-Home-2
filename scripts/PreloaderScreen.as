package
{
   import flash.display.MovieClip;
   
   public dynamic class PreloaderScreen extends MovieClip
   {
       
      
      public var blinkers:MovieClip;
      
      public var bar:MovieClip;
      
      public var wheel:MovieClip;
      
      public function PreloaderScreen()
      {
         super();
         addFrameScript(0,this.frame1,51,this.frame52,57,this.frame58,59,this.frame60,99,this.frame100);
      }
      
      internal function frame100() : *
      {
         stop();
      }
      
      internal function frame60() : *
      {
         stop();
      }
      
      internal function frame52() : *
      {
         stop();
      }
      
      internal function frame1() : *
      {
         gotoAndPlay("intro");
      }
      
      internal function frame58() : *
      {
         stop();
      }
   }
}
