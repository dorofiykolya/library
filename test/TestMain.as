package  
{
	import common.injection.Injector;
	import flash.display.Sprite;
	import mvc.MVCContext;
	
	/**
	 * ...
	 * @author dorofiy.com
	 */
	public class TestMain extends Sprite 
	{
		
		public function TestMain() 
		{
			var i:Injector = new Injector();
			
			i.map(ITestInject).toSingleton(TestInjection);
			
			var t:TestInto = new TestInto();
			i.inject(t);
			
			trace(t.into.log());
			
			new MVCContext();
			
		}
	}
}