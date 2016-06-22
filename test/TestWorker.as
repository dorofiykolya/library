package
{
	import flash.display.Sprite;
	import flash.system.Worker;
	
	/**
	 * ...
	 * @author dorofiy.com
	 */
	public class TestWorker extends Sprite
	{
		
		public function TestWorker()
		{
			trace("hello");
			if (!Worker.current.isPrimordial)
			{
				var a:int = 1;
				while (true)
				{
					a = 2 % 1;
				}
			}
		}
	}
}