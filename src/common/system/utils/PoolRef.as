package common.system.utils
{
	import common.system.TypeObject;
	
	/**
	 * ...
	 * @author dorofiy.com
	 */
	public class PoolRef extends TypeObject
	{
		internal var isDisposed:Boolean;
		internal var isPreDisposed:Boolean;
		internal var pool:PoolFactory;
		internal var targetType:Class;
		
		public function PoolRef()
		{
		
		}
		
		public function get poolFactory():PoolFactory
		{
			return pool;
		}
		
		public function get disposed():Boolean
		{
			return isDisposed;
		}
		
		public function get type():Class
		{
			return targetType;
		}
	}
}