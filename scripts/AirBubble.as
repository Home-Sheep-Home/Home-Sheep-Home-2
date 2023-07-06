package
{
   import flash.display.MovieClip;
   
   public dynamic class AirBubble extends MovieClip
   {
       
      
      public function AirBubble()
      {
         super();
         addFrameScript(0,this.frame1,13,this.frame14);
      }
      
      internal function frame14() : *
      {
         if(parent)
         {
            MovieClip(parent).removeChild(this);
         }
         stop();
      }
      
      internal function frame1() : *
      {
         stop();
      }
   }
}
