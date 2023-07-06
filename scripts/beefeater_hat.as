package
{
   import com.aardman.clips.BeefeaterHat;
   
   public dynamic class beefeater_hat extends BeefeaterHat
   {
       
      
      public function beefeater_hat()
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
