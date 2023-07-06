package
{
   import com.aardman.app.App;
   import com.aardman.app.DevPanel;
   import com.aardman.app.Hooks;
   import com.aardman.app.Levels;
   import com.aardman.app.Settings;
   import com.aardman.utils.SmartCache;
   import com.amanitadesign.steam.FRESteamWorks;
   import com.amanitadesign.steam.SteamEvent;
   import com.deeperbeige.lib3as.*;
   import flash.desktop.*;
   import flash.display.*;
   import flash.events.*;
   import flash.filesystem.*;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.system.Capabilities;
   
   public class AIRCalls
   {
      
      private static const settingsFile:String = "settings.txt";
      
      private static const settingsBackupFile:String = "settings.old";
      
      private static const saveFile:String = "savedata.txt";
      
      private static const saveBackupFile:String = "savedata.old";
      
      public static var stage:Stage;
      
      private static var window:NativeWindow;
      
      private static var windowActive:Boolean = false;
      
      public static var steamworks:FRESteamWorks;
       
      
      public function AIRCalls()
      {
         super();
      }
      
      public static function init() : void
      {
         SmartCache.init();
         if(Hooks.steamDisabled)
         {
            return;
         }
         steamworks = new FRESteamWorks();
         steamworks.addEventListener(SteamEvent.STEAM_RESPONSE,onSteamResponse);
         if(!steamworks.init())
         {
            DevPanel.log("Unable to initialise Steamworks API");
         }
      }
      
      public static function awardSteamAchievement(param1:String) : void
      {
         if(!steamworks || !steamworks.isReady)
         {
            DevPanel.log("Could not award " + param1 + ": Steamworks not ready");
            return;
         }
         if(steamworks.isAchievement(param1))
         {
            return;
         }
         steamworks.setAchievement(param1);
      }
      
      private static function onSteamResponse(param1:SteamEvent) : void
      {
      }
      
      public static function determineInitialSettings() : void
      {
         if(Boolean(window) && !windowActive)
         {
            window.activate();
            windowActive = true;
         }
         DevPanel.log("Determining initial settings");
         DevPanel.log("Fullscreen stage size: " + stage.stageWidth + "x" + stage.stageHeight);
         Hooks.trackingEvent("resolution",Capabilities.screenResolutionX + "x" + Capabilities.screenResolutionY);
         Settings.adjustScreenSize(5);
         while(480 * App.inst.appScale > stage.stageHeight)
         {
            Settings.adjustScreenSize(-1);
            setWindowSize();
            if(App.inst.appScale <= 1)
            {
               break;
            }
         }
         DevPanel.log("Picked optimum resolution: " + Settings.screenWidth + "x" + Settings.screenHeight);
         if(Settings.gpuAvailable)
         {
            Settings.performance = "recommended";
            Settings.adjustPerformance(0);
         }
         else
         {
            Settings.performance = "medium";
            Settings.adjustPerformance(0);
         }
         Settings.saveToSO();
      }
      
      public static function setWindowSize() : void
      {
         Settings.adjustScreenSize(0);
         Settings.gpuAvailable = stage.wmodeGPU;
         adjustTextureScale();
         if(!Settings.windowed)
         {
            return;
         }
         stage.nativeWindow.width = Settings.screenWidth;
         stage.nativeWindow.height = Settings.screenHeight;
         var _loc1_:int = Settings.screenWidth - stage.stageWidth;
         var _loc2_:int = Settings.screenHeight - stage.stageHeight;
         stage.nativeWindow.width = Settings.screenWidth + _loc1_;
         stage.nativeWindow.height = Settings.screenHeight + _loc2_;
      }
      
      public static function setFullscreenOrWindowed() : void
      {
         if(Settings.windowed)
         {
            stage.displayState = StageDisplayState.NORMAL;
            stage.scaleMode = StageScaleMode.NO_SCALE;
         }
         else
         {
            if(Boolean(window) && !windowActive)
            {
               window.activate();
               windowActive = true;
            }
            stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
            stage.scaleMode = StageScaleMode.NO_SCALE;
         }
         setWindowSize();
         centreNativeWindow();
         DevPanel.log("Window size " + Settings.screenWidth + "x" + Settings.screenHeight);
         DevPanel.log("Screen size " + Capabilities.screenResolutionX + "x" + Capabilities.screenResolutionY);
         DevPanel.log("Stage size  " + stage.stageWidth + "x" + stage.stageHeight);
      }
      
      public static function adjustTextureScale() : void
      {
         var _loc1_:int = 0;
         var _loc2_:int = 0;
         if(Settings.windowed)
         {
            App.inst.clip.x = 0;
            App.inst.clip.y = 0;
            App.inst.clip.texture.scaleX = 1;
            App.inst.clip.texture.scaleY = 1;
            App.inst.clip.texture.x = 0;
            App.inst.clip.texture.y = 0;
         }
         else
         {
            App.inst.clip.texture.scaleX = stage.stageWidth / 640 / Settings.appScale;
            App.inst.clip.texture.scaleY = stage.stageHeight / 480 / Settings.appScale;
            _loc1_ = (stage.stageWidth - Settings.screenWidth) / 2;
            _loc2_ = (stage.stageHeight - Settings.screenHeight) / 2;
            App.inst.clip.x = _loc1_;
            App.inst.clip.y = _loc2_;
            App.inst.clip.texture.x = -_loc1_ / Settings.appScale;
            App.inst.clip.texture.y = -_loc2_ / Settings.appScale;
         }
      }
      
      public static function startWindowEventListeners() : void
      {
         stage.nativeWindow.addEventListener(Event.CLOSING,windowClosing,false,0,true);
         stage.nativeWindow.addEventListener(Event.CLOSE,windowClosed,false,0,true);
         stage.nativeWindow.addEventListener(NativeWindowBoundsEvent.MOVING,windowAboutToMove,false,0,true);
         stage.nativeWindow.addEventListener(NativeWindowBoundsEvent.MOVE,windowHasMoved,false,0,true);
      }
      
      public static function closeApplication() : void
      {
         NativeApplication.nativeApplication.exit();
      }
      
      public static function loadLayer(param1:String, param2:int) : MovieClip
      {
         var _loc3_:File = File.applicationDirectory.resolvePath("assets/bg/" + Settings.screenSize + "/" + param1 + Maths.formatNum(param2,3) + ".png");
         if(!_loc3_.exists)
         {
            return null;
         }
         DevPanel.log("Loading layer: " + _loc3_.nativePath);
         var _loc4_:MovieClip = new MovieClip();
         SmartCache.getAsset(_loc3_.url,evtLayerLoaded,[_loc4_]);
         return _loc4_;
      }
      
      private static function evtLayerLoaded(param1:Bitmap, param2:MovieClip) : void
      {
         var _loc3_:BitmapData = null;
         var _loc4_:BitmapData = null;
         _loc3_ = param1.bitmapData;
         var _loc5_:Rectangle = _loc3_.getColorBoundsRect(4294967295,0,false);
         (_loc4_ = new BitmapData(_loc5_.width,_loc5_.height)).copyPixels(_loc3_,_loc5_,new Point(0,0));
         param1.bitmapData = _loc4_;
         _loc3_.dispose();
         param2.scaleX = 640 / Settings.screenWidth;
         param2.scaleY = param2.scaleX;
         param2.x = param2.scaleX * _loc5_.left;
         param2.y = param2.scaleY * _loc5_.top;
         param2.addChild(param1);
      }
      
      private static function windowClosing(param1:Event) : void
      {
         stage.nativeWindow.removeEventListener(Event.CLOSING,windowClosing);
         Levels.processUnlocks();
         Levels.saveToSO();
      }
      
      private static function windowClosed(param1:Event) : void
      {
         stage.nativeWindow.removeEventListener(Event.CLOSE,windowClosed);
      }
      
      private static function windowAboutToMove(param1:NativeWindowBoundsEvent) : void
      {
      }
      
      private static function windowHasMoved(param1:NativeWindowBoundsEvent) : void
      {
      }
      
      public static function wipeSettingsFile() : void
      {
         var _loc1_:File = File.applicationStorageDirectory.resolvePath(settingsFile);
         if(_loc1_.exists)
         {
            _loc1_.deleteFile();
         }
      }
      
      public static function isSettingsFileValid() : Boolean
      {
         var _loc1_:File = File.applicationStorageDirectory.resolvePath(settingsFile);
         if(!_loc1_.exists)
         {
            return false;
         }
         var _loc2_:FileStream = new FileStream();
         _loc2_.open(_loc1_,FileMode.READ);
         var _loc3_:String = String(_loc2_.readMultiByte(_loc2_.bytesAvailable,"utf-8"));
         _loc2_.close();
         var _loc5_:Array;
         var _loc4_:RegExp;
         if(!(_loc5_ = (_loc4_ = /version\: *?(\d+)/i).exec(_loc3_)))
         {
            return false;
         }
         if(!_loc5_.length == 2)
         {
            return false;
         }
         if(int(_loc5_[1]) != Settings.ver)
         {
            return false;
         }
         return true;
      }
      
      public static function loadSettingsFromFile() : void
      {
         var _loc1_:File = File.applicationStorageDirectory.resolvePath(settingsFile);
         if(!_loc1_.exists)
         {
            return;
         }
         var _loc2_:FileStream = new FileStream();
         _loc2_.open(_loc1_,FileMode.READ);
         var _loc3_:String = String(_loc2_.readMultiByte(_loc2_.bytesAvailable,"utf-8"));
         _loc2_.close();
         Settings.fromString(_loc3_);
      }
      
      public static function saveSettingsToFile() : void
      {
         backupSettingsFile();
         wipeSettingsFile();
         var _loc1_:File = File.applicationStorageDirectory.resolvePath(settingsFile);
         var _loc2_:FileStream = new FileStream();
         _loc2_.open(_loc1_,FileMode.WRITE);
         _loc2_.writeMultiByte(Settings.asString(),"utf-8");
         _loc2_.close();
      }
      
      public static function backupSettingsFile() : void
      {
         var _loc1_:File = File.applicationStorageDirectory.resolvePath(settingsFile);
         var _loc2_:File = File.applicationStorageDirectory.resolvePath(settingsBackupFile);
         if(!_loc1_.exists)
         {
            return;
         }
         _loc1_.copyTo(_loc2_,true);
      }
      
      public static function wipeSaveFile() : void
      {
         var _loc1_:File = File.applicationStorageDirectory.resolvePath(saveFile);
         if(_loc1_.exists)
         {
            _loc1_.deleteFile();
         }
      }
      
      public static function loadSaveFromFile() : void
      {
         var _loc1_:File = File.applicationStorageDirectory.resolvePath(saveFile);
         DevPanel.log("Loading save-data from " + _loc1_.nativePath);
         if(!_loc1_.exists)
         {
            Levels.initialiseSO();
            return;
         }
         var _loc2_:FileStream = new FileStream();
         _loc2_.open(_loc1_,FileMode.READ);
         var _loc3_:String = String(_loc2_.readMultiByte(_loc2_.bytesAvailable,"utf-8"));
         _loc2_.close();
         Levels.fromString(_loc3_);
      }
      
      public static function saveSaveToFile() : void
      {
         backupSaveFile();
         wipeSaveFile();
         var _loc1_:File = File.applicationStorageDirectory.resolvePath(saveFile);
         var _loc2_:FileStream = new FileStream();
         _loc2_.open(_loc1_,FileMode.WRITE);
         _loc2_.writeMultiByte(Levels.asString(),"utf-8");
         _loc2_.close();
      }
      
      public static function backupSaveFile() : void
      {
         var _loc1_:File = File.applicationStorageDirectory.resolvePath(saveFile);
         var _loc2_:File = File.applicationStorageDirectory.resolvePath(saveBackupFile);
         if(!_loc1_.exists)
         {
            return;
         }
         _loc1_.copyTo(_loc2_,true);
      }
      
      public static function centreNativeWindow(param1:int = -1, param2:int = -1) : void
      {
         if(!Settings.windowed && param1 == -1 && param2 == -1)
         {
            return;
         }
         var _loc3_:int = Capabilities.screenResolutionX;
         var _loc4_:int = Capabilities.screenResolutionY;
         if(param1 < 0)
         {
            param1 = int(stage.nativeWindow.width);
         }
         if(param2 < 0)
         {
            param2 = int(stage.nativeWindow.height);
         }
         stage.nativeWindow.x = _loc3_ / 2 - param1 / 2;
         stage.nativeWindow.y = _loc4_ / 2 - param2 / 2;
         if(Boolean(window) && !windowActive)
         {
            window.activate();
            windowActive = true;
         }
      }
      
      public static function createNativeWindow() : DisplayObjectContainer
      {
         var _loc1_:NativeWindowInitOptions = new NativeWindowInitOptions();
         _loc1_.resizable = false;
         _loc1_.maximizable = false;
         _loc1_.minimizable = true;
         _loc1_.owner = null;
         _loc1_.transparent = false;
         _loc1_.renderMode = NativeWindowRenderMode.GPU;
         _loc1_.systemChrome = NativeWindowSystemChrome.STANDARD;
         _loc1_.type = NativeWindowType.NORMAL;
         window = new NativeWindow(_loc1_);
         window.title = "Home Sheep Home 2";
         window.stage.scaleMode = StageScaleMode.NO_SCALE;
         window.stage.align = StageAlign.TOP_LEFT;
         window.bounds = new Rectangle(100,100,640,480);
         stage.nativeWindow.close();
         stage = window.stage;
         return stage;
      }
   }
}
