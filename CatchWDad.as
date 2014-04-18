package
{
	import com.capsizedstudios.Game;
	
	import flash.system.Capabilities;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.geom.Rectangle;
	import flash.filesystem.File;
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.desktop.NativeApplication;
	
	import starling.core.Starling;
	import starling.utils.RectangleUtil;
	import starling.utils.ScaleMode;
	import starling.utils.AssetManager;
	import starling.utils.formatString;
	import starling.events.Event;
	import starling.textures.Texture;
	
	[SWF(width="960", height="640", frameRate="60", backgroundColor="#009933")]
	
	public class CatchWDad extends Sprite
	{
		// Startup image for SD screens
		[Embed(source="assets/textures/grassBackground.jpg")]
		private static var Background:Class;
		
		// Startup image for HD screens
		[Embed(source="assets/textures/grassBackgroundHD.jpg")]
		private static var BackgroundHD:Class;
		
		//Create Starling instance
		private var mStarling:Starling;
		
		public function CatchWDad()
		{
			//detect if IOS
			var iOS:Boolean = Capabilities.manufacturer.indexOf("iOS") != -1;
			
			var stageWidth:int  = 640;
			var stageHeight:int = 960;
			
//			Starling.multitouchEnabled = true;  // useful on mobile devices
			Starling.handleLostContext = !iOS;  // not necessary on iOS. Saves a lot of memory!
			
			var viewPort:Rectangle = RectangleUtil.fit(
				new Rectangle(0, 0, stageWidth, stageHeight), 
				new Rectangle(0, 0, stage.fullScreenWidth, stage.fullScreenHeight), 
				ScaleMode.SHOW_ALL, iOS);
			
			var scaleFactor:int = viewPort.width < 960 ? 1 : 2; // midway between 320 and 640
			var appDir:File = File.applicationDirectory;
			var assets:AssetManager = new AssetManager(scaleFactor);
			assets.verbose = true;

			assets.verbose = Capabilities.isDebugger;
			assets.enqueue(
				appDir.resolvePath("assets/audio"),
				appDir.resolvePath(formatString("assets/fonts/{0}x", scaleFactor)),
				appDir.resolvePath(formatString("assets/textures/{0}x", scaleFactor))
			);
				
			// While Stage3D is initializing, the screen will be blank. To avoid any flickering, 
			// we display a startup image now and remove it below, when Starling is ready to go.
			// This is especially useful on iOS, where "Default.png" (or a variant) is displayed
			// during Startup. You can create an absolute seamless startup that way.
			// 
			// These are the only embedded graphics in this app. We can't load them from disk,
			// because that can only be done asynchronously - i.e. flickering would return.
			// 
			// Note that we cannot embed "Default.png" (or its siblings), because any embedded
			// files will vanish from the application package, and those are picked up by the OS!
			
			var backgroundClass:Class = scaleFactor == 1 ? Background : BackgroundHD;
			var background:Bitmap = new backgroundClass();
			Background = BackgroundHD = null; // no longer needed!
			viewPort.x=0;
			viewPort.y=0;
			background.x = viewPort.x;
			background.y = viewPort.y;
			background.width  = viewPort.width;
			background.height = viewPort.height;
			background.smoothing = true;
			addChild(background);
			
			// launch Starling
			
			mStarling = new Starling(Game, stage, viewPort);
			mStarling.stage.stageWidth  = stageWidth;  // <- same size on all devices!
			mStarling.stage.stageHeight = stageHeight; // <- same size on all devices!
			mStarling.simulateMultitouch  = false;
			mStarling.enableErrorChecking = false;
			
			mStarling.addEventListener(starling.events.Event.ROOT_CREATED, function():void
			{
				removeChild(background);
				background = null;
				
				var game:Game = mStarling.root as Game;
				var bgTexture:Texture = Texture.fromEmbeddedAsset(backgroundClass, false, false, scaleFactor); 
				game.Start(bgTexture, assets);
				mStarling.start();
			});
			
			// When the game becomes inactive, we pause Starling; otherwise, the enter frame event
			// would report a very long 'passedTime' when the app is reactivated. 
			
			NativeApplication.nativeApplication.addEventListener(
				flash.events.Event.ACTIVATE, function (e:*):void { mStarling.start(); });
			
			NativeApplication.nativeApplication.addEventListener(
				flash.events.Event.DEACTIVATE, function (e:*):void { mStarling.stop(true); });
		}
	}
}