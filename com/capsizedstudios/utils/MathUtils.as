package com.capsizedstudios.utils
{
	import starling.display.Sprite;
	
	public class MathUtils extends Sprite
	{
		public function MathUtils(){
			
		}
		
		public static function randomRange(minNum:int, maxNum:int):int{
			return (Math.floor(Math.random() * (maxNum - minNum + 1)) + minNum);
		}
		
	}
}