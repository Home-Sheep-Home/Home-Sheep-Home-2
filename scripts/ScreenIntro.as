package
{
   import com.deeperbeige.insulation.SoundInsulation;
   import flash.display.MovieClip;
   
   public dynamic class ScreenIntro extends MovieClip
   {
       
      
      public var shaun:MovieClip;
      
      public var clouds:MovieClip;
      
      public var timmy:MovieClip;
      
      public var shirley:MovieClip;
      
      public var startButtonHolder:MovieClip;
      
      public function ScreenIntro()
      {
         super();
         addFrameScript(0,this.frame1,176,this.frame177,182,this.frame183,195,this.frame196,220,this.frame221,226,this.frame227);
      }
      
      internal function frame1() : *
      {
      }
      
      internal function frame177() : *
      {
         SoundInsulation.play("shaunland");
      }
      
      internal function frame183() : *
      {
         SoundInsulation.play("jumptimmy");
      }
      
      internal function frame196() : *
      {
         SoundInsulation.play("timmyland");
      }
      
      internal function frame221() : *
      {
         SoundInsulation.play("shirleyland");
      }
      
      internal function frame227() : *
      {
         stop();
      }
   }
}
