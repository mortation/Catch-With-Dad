package com.capsizedstudios.cwd
{
	import com.capsizedstudios.cwd.Ball;
	import com.capsizedstudios.cwd.NPC;
	import com.capsizedstudios.cwd.Player;
	
	import starling.display.Quad;
	import starling.display.Sprite;
	import starling.display.Stage;
	import starling.events.Event;
	import starling.text.TextField;
	import starling.utils.Color;
	import starling.utils.HAlign;
	import starling.utils.VAlign;
	
	public class ScoreHUD extends Sprite
	{
		public var score:TextField;
		public var gameTimer:TextField;
		public var scoreBox:Quad;
		
		private var currentScore:int;
		private var thisStage:Stage;
		
		public function ScoreHUD(stageRef:Stage):void{
			this.thisStage = stageRef;
			this.addEventListener(Event.ADDED_TO_STAGE, Init);
		}
		
		private function Init(e:Event){
			currentScore = 0;
			
			scoreBox = new Quad(200,40);
			scoreBox.setVertexColor(0, Color.WHITE);
			scoreBox.setVertexAlpha(0,.5);
			scoreBox.setVertexAlpha(1,.5);
			scoreBox.setVertexAlpha(2,.5);
			scoreBox.setVertexAlpha(3,.5);
			
			score = new TextField(200, 40, "text", "Arial", 24, Color.RED, true);
			
			score.hAlign = HAlign.CENTER;  // horizontal alignment
			score.vAlign = VAlign.CENTER; // vertical alignment
			score.border = true;
			score.alpha  = 50;
			
			score.text="Score: "+currentScore;
			addChild(this.scoreBox);
			addChild(this.score);
			this.removeEventListener(Event.ADDED_TO_STAGE, Init);
		}
		
		public function addPoint(){
			this.currentScore++;
			this.score.text="Score: "+currentScore;
		}
		
		public function removePoint(){
			if(this.currentScore > 0){
				this.currentScore--;
			}
			this.score.text="Score: "+currentScore;
		}
		
		public function Score(){

		}
	}
}