package
{
	import common.entity.Behaviour;
	
	/**
	 * ...
	 * @author dorofiy.com
	 */
	public class TestComponent extends Behaviour
	{
		
		public function TestComponent()
		{
			
		}
		
		public function blabla(time:Number):void
		{
			trace("blabla:" + time);
		}
		
		//public function update():void
		//{
			//trace("update");
		//}
		
		//override protected function attach():void
		//{
			//trace("attach");
		//}
		//
		//override protected function detach():void
		//{
			//trace("detach");
		//}
		//
		//public function log():void
		//{
			//
		//}
	}
}