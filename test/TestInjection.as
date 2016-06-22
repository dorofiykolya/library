package
{
	/**
	 * ...
	 * @author dorofiy.com
	 */
	public class TestInjection implements ITestInject 
	{
		
		public function TestInjection() 
		{
			
		}
		
		/* INTERFACE test.ITestInject */
		
		public function log():void 
		{
			trace(Math.random());
		}
		
	}

}