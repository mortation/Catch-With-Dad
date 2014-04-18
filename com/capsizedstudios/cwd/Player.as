package com.capsizedstudios.cwd
{
	import com.capsizedstudios.cwd.Ball;
	
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	import flash.text.TextColorType;
	import flash.text.TextRenderer;
	import flash.utils.Timer;
	
	import feathers.controls.Button;
	import feathers.controls.Callout;
	import feathers.controls.Label;
	import feathers.themes.MetalWorksMobileTheme;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.display.Stage;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	import starling.utils.Color;

	public class Player extends Sprite
	{
		private var playerCeiling:int;
		private var thisStage:Stage;
		private var playerImage:Image;//Switching this to private was why I could no longer read the value x/y correctly dumbass
		private var theme:MetalWorksMobileTheme;
		
		public var ballObj:Ball;
		public var hasBall:Boolean;
		public var canThrow:Boolean;
		
		public var glove:Rectangle;
		public var hitBox:Rectangle;

		public function Player(texture:Texture, stageRef:Stage)
		{
			hasBall		= true; // player starts with ball.
			canThrow    = false;
			thisStage   = stageRef;
			playerImage = new Image(texture);
			glove 		= new Rectangle(playerImage.x, playerImage.y,74,23);
			hitBox		= new Rectangle(playerImage.x+74, playerImage.y, playerImage.width-74, playerImage.height);
			theme		= new MetalWorksMobileTheme();

			this.addEventListener(Event.ADDED_TO_STAGE, Init);
		}
		
		private function Init(e:Event){
			//Get player character start position on stage, update public point startLocation
			var startLocation:Point = this.GetPlayerStartLocation();
			
			this.playerImage.x = startLocation.x;
			this.playerImage.y = startLocation.y;
			
			this.playerImage.addEventListener(TouchEvent.TOUCH, Move);
			this.playerImage.addEventListener(Event.ENTER_FRAME, playerLoop);
			
			addChild(this.playerImage);
			
			this.removeEventListener(Event.ADDED_TO_STAGE, Init);
		}
		
		private function GetPlayerStartLocation():Point{
			var startLocation:Point = new Point();
			
			var startX = (thisStage.stageWidth*.5) - (playerImage.width*.5);
			var startY = thisStage.stageHeight*.75;
			
			startLocation.x = startX;
			startLocation.y = startY;
			
			return startLocation;
		}
		
		private function playerLoop(e:Event){
			
			//If I have the ball keep it with me
			//Originaly had this in the ball class but the ball class never accurately reads the player y position
			if(this.hasBall == true){
				this.ballObj.ballImage.x = this.playerImage.x+this.playerImage.width;
				this.ballObj.ballImage.y = this.playerImage.y;
			}
		}
		
		public function Move(e:TouchEvent){
			var touch:Touch = e.getTouch(thisStage);
			var playerCeiling:int = thisStage.stageHeight*.66;
			var playerBase:int = thisStage.stageHeight - this.playerImage.height/2;
			
			if(touch.phase == TouchPhase.MOVED ){
				var position:Point = touch.getLocation(thisStage);
				
				var Y:int = position.y - this.playerImage.height/2;
				var X:int = position.x - this.playerImage.width;
				
				if(X > 0 && X < (thisStage.stageWidth-this.playerImage.width)){
					this.playerImage.x = X;
				}
					
				if(Y < (playerBase-this.playerImage.height) && Y > playerCeiling){
					this.playerImage.y = Y;
				}
			}
			
			//Keep my 2 hit boxes in line with player
			glove.x = this.playerImage.x;// = new Rectangle(playerImage.x, playerImage.y,74,23);
			glove.y = this.playerImage.y;
			hitBox.x = this.playerImage.x+glove.width;// = new Rectangle(playerImage.x+74, playerImage.y, playerImage.width-74, playerImage.height);
			hitBox.y = this.playerImage.y;
			
			if(touch.phase == TouchPhase.ENDED && (this.hasBall == true && this.canThrow == true)){
				this.ballObj.ThrowBall("Player");
			}
		}
		
		public function Speak(words:String){
			theme.setInitializerForClass(Label, customLabelInitializer, "customLabel");
			const label:Label = new Label();
			label.nameList.add("customLabel");
			label.text = words;
			
			Callout.show(label, this.playerImage, Callout.DIRECTION_UP, false);
		}
		
		private function customLabelInitializer( label:Label ):void
		{
			label.textRendererProperties.textFormat = new TextFormat(null, 36, Color.RED);
			label.textRendererProperties.embedFonts = true;
		}
	}
}