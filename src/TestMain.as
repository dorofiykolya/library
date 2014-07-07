package  
{
	import common.composite.Component;
	import common.composite.Entity;
	import common.injection.Injector;
	import flash.display.Sprite;
	import test.ITestInject;
	import test.TestInjection;
	import test.TestInto;
	
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
			
		}
	}
}