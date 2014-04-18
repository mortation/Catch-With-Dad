package com.capsizedstudios.cwd
{
	import com.capsizedstudios.cwd.Ball;
	import com.capsizedstudios.utils.MathUtils;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.TextFormat;
	
	import feathers.controls.Button;
	import feathers.controls.Callout;
	import feathers.controls.Label;
	import feathers.themes.MetalWorksMobileTheme;
	
	import starling.animation.Tween;
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.display.Stage;
	import starling.events.Event;
	import starling.textures.Texture;
	import starling.utils.Color;
	import starling.utils.deg2rad;
	
	public class NPC extends Sprite
	{
		private var thisStage:Stage;
		private var npcBase:Number;
		private var npcCeiling:Number;
		
		//Variables for controlling NPC random movement
		private var xReached:Boolean;
		private var yReached:Boolean;
		private var xDest:int;
		private var yDest:int;
		private var vy:Number; //y velocity
		private var ay:Number; //y acceleration
		private var vx:Number; //x velocity
		private var ax:Number; //x acceleration
		private var xDir:String;
		private var yDir:String;
		private var waitFrames:int;
		
		//Public variables for controlling npc speed and ball position
		public var hasBall:Boolean;
		public var chaseBall:Boolean;
		public var wasChasingBall:Boolean;
		public var canThrow:Boolean;
		
		public var velocity:Number;
		public var acceleration:Number;
		public var frameDelay:int;
		
		public var npcImage:Image;
		public var ballObj:Ball;
		public var glove:Rectangle;
		public var hitBox:Rectangle;
		
		public function NPC(texture:Texture, stageRef:Stage)
		{
			thisStage 		 = stageRef;
			wasChasingBall   = false;
			canThrow		 = false;
			chaseBall		 = false;
			xReached  		 = true;
			yReached  		 = true;
			hasBall   		 = false;//NPC doesnt start with ball
			waitFrames		 = 0;
			frameDelay		 = 45;
			xDest 	  		 = 0;
			yDest 	  		 = 0;
			velocity		 = .2;
			acceleration	 = .05;
			vy	 			 = velocity;  	 // y velocity
			ay 				 = acceleration; // y acceleration
			vx 				 = velocity;  	 // x velocity
			ax 				 = acceleration; // x acceleration
			
			new MetalWorksMobileTheme();
			npcImage = new Image(texture);
			glove 	 = new Rectangle(npcImage.x+(npcImage.width-74), npcImage.y+npcImage.height,74,23);
			hitBox	 = new Rectangle(npcImage.x, npcImage.y+npcImage.height, npcImage.width-74, npcImage.height);
			
			this.addEventListener(Event.ADDED_TO_STAGE, Init);
		}
		
		private function Init(){
			this.npcImage.addEventListener(Event.ENTER_FRAME, NPCMove);
			addChild(this.npcImage);
			this.removeEventListener(Event.ADDED_TO_STAGE, Init);
		}
		
		public function NPCMove(e:Event){

			var npcCeiling:Number = thisStage.stageHeight*.33;
			
			//Frame delay counter to pause npc at reached destination
			if(waitFrames > 0){
				waitFrames--;
			}
			
			//Ball tossed off the field, stop and go get it
			if(this.chaseBall == true && this.wasChasingBall == false){
				waitFrames = 0;
				xReached = true;
				yReached = true;
				this.wasChasingBall = true;
				
				xDest = this.ballObj.ballImage.x;
				yDest = 0-(this.npcImage.height+5);
				
				this.npcImage.pivotX = this.npcImage.width/2;
				this.npcImage.pivotY = this.npcImage.height/2;
				this.npcImage.rotation = 3.14158;
			}
			
			//If npc has reached last destination and finished waiting
			if(xReached == true && yReached == true && waitFrames == 0){

				//See if NPC is chasing an off screen ball or not
				if(this.chaseBall == false){
					xDest = MathUtils.randomRange(0,(thisStage.stageWidth - npcImage.width));
					yDest = MathUtils.randomRange(0, npcCeiling);
				}
				
				xReached = false;
				yReached = false;
				xDir = null;
				yDir = null;
					
				// Velocity of movement
				// Reset each time coordinates change
				vy = ay;
				vx = ax;
				
				if(this.hasBall == true && this.canThrow == true){
					this.ballObj.ThrowBall("NPC");
				}
			}
				
			if(xReached == false){
				//Accelerate the more (S)hes moving
				vx += ax;
				
				if(xDest < npcImage.x){
					npcImage.x -= vx;
					xDir = "Left"
				}else{
					npcImage.x += vx;
					xDir = "Right"
				}
				
				if(xDir == "left"){
					if(Math.round(npcImage.x) <= xDest){
						xReached = true;
					}
				} else if(xDir == "Right"){
					if(Math.round(npcImage.x) >= xDest){
						xReached = true;
					}
				}
			}
			
			if(yReached == false){
				//Accelerate the more (S)hes moving
				vy += ay;
				
				if(yDest < npcImage.y){
					npcImage.y -= vy;
					yDir = "Up"
				}else{
					npcImage.y += vy;
					yDir = "Down"
				}
			
				if(yDir == "Up"){
					if(Math.round(npcImage.y) <= yDest){
						yReached = true;
					}
				} else if(yDir == "Down"){
					if(Math.round(npcImage.y) >= yDest){
						yReached = true;
					}
				}
			}

			if(xReached == true && yReached == true && waitFrames == 0){

				//Got to the stray ball
				if(this.chaseBall == true){
					this.npcImage.rotation = Math.PI*2;
					this.npcImage.pivotX = 0;
					this.npcImage.pivotY = 0;
					
					this.chaseBall = false;
					this.ballObj.HasBall("NPC");
					this.canThrow = false;
					
				}else if(this.chaseBall == false && this.wasChasingBall == true && this.canThrow == false){
					//back on screen after getting ball, can throw again
					this.wasChasingBall = false;
					this.canThrow 		= true;
				}
				
				waitFrames = frameDelay;
			}
			
			glove.x = npcImage.x+(npcImage.width-74);
			glove.y = npcImage.y+npcImage.height;
			hitBox.x = npcImage.x;
			hitBox.y = npcImage.y+npcImage.height;
			
			//If I have the ball keep it with me
			if(this.hasBall == true){
				this.ballObj.ballImage.x = npcImage.x;
				this.ballObj.ballImage.y = npcImage.y+npcImage.height;
			}
		}
		
		public function Speak(words:String){
			const label:Label = new Label();
			label.text = words;
			label.textRendererProperties.textFormat = new TextFormat(null, 48, Color.RED);
			label.textRendererProperties.embedFonts = true;
			
			Callout.show(label, this.npcImage, Callout.DIRECTION_DOWN, false);
		}
	}
}