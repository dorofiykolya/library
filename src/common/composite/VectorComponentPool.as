package common.composite
{
	import common.system.Cache;
	import common.system.ClassType;
	
	/**
	 * ...
	 * @author dorofiy.com
	 */
	public class VectorComponentPool
	{
		private static const POOL:Vector.<Component> = new Vector.<Component>();
		
		public function VectorComponentPool()
		{
		
		}
		
		public static function push(vector:Vector.<Component>):void
		{
			vector.length = 0;
			POOL.push(vector);
		}
		
		public static function pop():Vector.<Component>
		{
			if (POOL.length != 0)
			{
				POOL.pop();
			}
			return new Vector.<Component>();
		}
	
	}

}