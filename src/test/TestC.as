package test 
{
	import common.composite.Component;
	
	/**
	 * ...
	 * @author dorofiy.com
	 */
	public class TestC extends Component 
	{
		
		public function TestC(name:String = "CCC") 
		{
			super();
			this.name = name;
		}
		
		public function update():void
		{
			trace(toString(), name);
		}
		
	}

}