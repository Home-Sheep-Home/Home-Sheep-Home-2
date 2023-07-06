package
{
   import flash.display.MovieClip;
   
   public dynamic class SmokeParticle extends MovieClip
   {
       
      
      public function SmokeParticle()
      {
         super();
         addFrameScript(34,this.frame35);
      }
      
      internal function frame35() : *
      {
         if(parent)
         {
            MovieClip(parent).removeChild(this);
         }
         stop();
      }
   }
}
