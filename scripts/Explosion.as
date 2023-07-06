package
{
   import flash.display.MovieClip;
   
   public dynamic class Explosion extends MovieClip
   {
       
      
      public function Explosion()
      {
         super();
         addFrameScript(18,this.frame19);
      }
      
      internal function frame19() : *
      {
         stop();
         if(parent)
         {
            MovieClip(parent).removeChild(this);
         }
      }
   }
}
