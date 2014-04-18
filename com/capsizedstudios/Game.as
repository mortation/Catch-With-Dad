package com.capsizedstudios
{
	import com.capsizedstudios.cwd.Ball;
	import com.capsizedstudios.cwd.NPC;
	import com.capsizedstudios.cwd.Player;
	import com.capsizedstudios.cwd.ScoreHUD;
	
	import flash.events.Event;
	import flash.geom.Point;
	
	import starling.display.Image;
	import starling.display.Sprite;
	import starling.events.Event;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;
	import starling.textures.Texture;
	import starling.utils.AssetManager;
	
	public class Game extends Sprite
	{
		private static var sAssets:AssetManager;
		private static var npcObj:NPC;
		private static var playerObj:Player;
		private static var ballObj:Ball;
		private static var scoreHud:ScoreHUD;
		
		private var gameState:String;
		private var prevGameState:String;
		
		public function Game() {
			//Not used, goes right to Start function after Starling Initialization
		}
		
		public function Start(background:Texture, assets:AssetManager):void{
			sAssets = assets;
			
			var bgTest:Image = new Image(background);
	
			//load ground grass background while pulling in all assets.  
			//Need to switch out for splash page in the future
			addChild(bgTest);
			
			sAssets.loadQueue(function(ratio:Number):void
			{
				trace("Loading assets, progress:", ratio);
				
				if (ratio == 1.0){
					IntializeGame();
				}
			});
		}
		
		private function IntializeGame(){
			npcObj		= new NPC(sAssets.getTexture("NPC"), this.stage);
			playerObj	= new Player(sAssets.getTexture("Player"), this.stage);
			ballObj		= new Ball(sAssets.getTexture("ball"), this.stage);
			scoreHud	= new ScoreHUD(this.stage);

			gameState 			  = "Start";
			
			addEventListener(Event.ENTER_FRAME, Main);
		}
		
		private function Main(){
			
			if(gameState != prevGameState){
				switch(gameState){
					case "Start":
						startGame();
						break;
					case "Play":
						PlayGame();
						trace("Play Game");
						break;
					case "Pause":
						trace("Pause Game");
						break;
					case "Game Over":
						trace("Game Over");
						break;
					case "Credits":
						trace("Credits");
						break;
					default:
						trace("Main Menu");
				}
			}
		}
		
		private function startGame(){
			//Cross reference all our objects
			playerObj.ballObj   = ballObj;
			npcObj.ballObj		= ballObj;
			ballObj.scoreHud	= scoreHud;
			ballObj.pCharacter  = playerObj;
			ballObj.npCharacter = npcObj;
			
			//load all our objects to the stage
			addChild(playerObj);
			addChild(npcObj);
			addChild(ballObj);
			addChild(scoreHud);

			ballObj.HasBall("Player");
			
			//Kick off game play
			gameState="Play";
		}
		
		private function PlayGame(){
			//Not sure if I will need a seperate play state from start game but worth inserting just in case.
			prevGameState = gameState;
		}
		
		public static function get assets():AssetManager { return sAssets; }
	}
}

