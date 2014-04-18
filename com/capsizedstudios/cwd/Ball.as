package com.capsizedstudios.cwd
{
	import com.capsizedstudios.cwd.NPC;
	import com.capsizedstudios.cwd.Player;
	import com.capsizedstudios.cwd.ScoreHUD;
	import com.capsizedstudios.utils.MathUtils;
	
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	
	import starling.display.Sprite;
	import starling.display.Image;
	import starling.display.Stage;
	import starling.events.Event;
	import starling.textures.Texture;
	
	public class Ball extends Sprite
	{
		private var thisStage:Stage;
		private var ay:Number;
		private var vy:Number;
		private var dy:Number;
		
		//References to other objects
		public var ballDirection:String;
		public var scoreHud:ScoreHUD;
		public var pCharacter:Player;
		public var npCharacter:NPC;
		
		//public variables for the ball
		public var ballImage:Image;
		public var inMotion:Boolean;
		public var velocity:Number;
		public var acceleration:Number;
		public var deceleration:Number;
		public var hitBox:Rectangle;
		
		public function Ball(texture:Texture, stageRef:Stage):void{
			thisStage 	 = stageRef;
			inMotion   	 = false;
			ballImage 	 = new Image(texture);
			velocity	 = MathUtils.randomRange(9,13);//10;
			acceleration = .05;
			deceleration = .05;
			ay 		  	 = acceleration;
			vy		  	 = velocity;
			dy			 = deceleration;
			
			hitBox = new Rectangle(ballImage.x, ballImage.y, ballImage.width, ballImage.height);

			this.addEventListener(Event.ADDED_TO_STAGE, Init);
		}
		
		private function Init(e:Event){
			this.ballImage.addEventListener(Event.ENTER_FRAME, BallLoop);
			addChild(this.ballImage);
			this.HasBall("Player");
			
			this.removeEventListener(Event.ADDED_TO_STAGE, Init);
		}
		
		public function BallLoop(e:Event){
			if(this.inMotion == false){
				// Reset velocity and acceleration for each pitch
				ay = acceleration;
				vy = velocity;
				dy = deceleration;
			} else {
				//Decrease velocity as the ball travels
				if(vy > .5){
					vy -= dy;
				} else if (vy < .5){
					vy = .5;
				}
			}
			
			//Ball Movement
			if(this.inMotion == true && this.ballDirection == "Up"){
				this.ballImage.y -= vy;
			}
			
			if(this.inMotion == true && this.ballDirection == "Down"){
				this.ballImage.y += vy;
			}
			
			//Ball collision box
			hitBox.x = ballImage.x;
			hitBox.y = ballImage.y;

			//Ball boundry and collision checking
			if(this.ballImage.y > (thisStage.stageHeight+this.ballImage.height) && this.ballDirection == "Down" && this.inMotion == true){
				this.scoreHud.removePoint();
				HasBall("Player");
			}
			
			if (ballImage.bounds.intersects(pCharacter.glove) && pCharacter.hasBall == false){
				this.npCharacter.Speak("Nice catch Dad!");
				this.scoreHud.addPoint();
				HasBall("Player");
			} else if(ballImage.bounds.intersects(pCharacter.hitBox) && pCharacter.hasBall == false && ballDirection == "Down"){
				this.scoreHud.removePoint();
				this.pCharacter.Speak("OUCH!");
				HasBall("Player");
			}
			
			if(this.ballImage.y < (0-(this.ballImage.height+5)) && this.ballDirection == "Up" && this.inMotion == true){
				this.scoreHud.removePoint();
				HasBall("");
			}
			
			if (ballImage.bounds.intersects(npCharacter.glove) && npCharacter.hasBall == false){
				this.pCharacter.Speak("Nice catch Kid!");
				this.scoreHud.addPoint();
				HasBall("NPC");
			} else if(ballImage.bounds.intersects(npCharacter.hitBox) && npCharacter.hasBall == false && ballDirection == "Up"){
				this.npCharacter.Speak("OUCH!");
				this.scoreHud.removePoint();
				HasBall("NPC");
			}
		}
		
		public function ThrowBall(char:String){
			this.inMotion  		   = true;
			trace(char+" has thrown the ball.");
			
			if(char == "Player"){
				this.ballDirection 	   = "Up";
				this.pCharacter.hasBall = false;
			} else {
				this.ballDirection 	   = "Down";
				this.npCharacter.hasBall = false;	
			}
		}
		
		public function HasBall(char:String){
			this.inMotion 			 = false;
			this.ballImage.visible	 = false;
			
			switch(char){
				case "Player":
					trace("Player has the ball");
					this.npCharacter.hasBall = false;
					this.pCharacter.hasBall  = true;
					this.pCharacter.canThrow = true;
					this.ballDirection 		 = null;
					this.ballImage.visible   = true;
					break;
				case "NPC":
					trace("NPC Has the ball");
					this.npCharacter.hasBall  = true;
					this.pCharacter.hasBall   = false;
					this.npCharacter.canThrow = true;
					this.ballDirection        = null;
					this.ballImage.visible    = true;
					break;
				default:
					//Lost the ball
					trace("Balls off on its own!");
					this.npCharacter.hasBall   = false;
					this.pCharacter.hasBall    = false;
					this.npCharacter.canThrow  = false;
					this.pCharacter.canThrow   = false;
					this.npCharacter.chaseBall = true;
			}
		}
	}
}