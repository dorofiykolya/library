package
{
	import common.composite.Entity;
	import common.system.utils.IPoolable;
	import common.system.utils.PoolRef;
	
	/**
	 * ...
	 * @author dorofiy.com
	 */
	public class TestE extends Entity
	{
		public function TestE(name:String="asd") 
		{
			super();
			this.name = name;
		}
		
		public function update(val:int):void
		{
			trace(toString(), name, val);
		}
	}
}