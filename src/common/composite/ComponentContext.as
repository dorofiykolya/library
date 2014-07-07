package common.composite
{
	import common.system.enums.BitFlagEnum;
	import common.system.TypeObject;
	
	/**
	 * ...
	 * @author dorofiy.com
	 */
	public class ComponentContext extends TypeObject
	{
		private static const POOL:Vector.<ComponentContext> = new Vector.<ComponentContext>(64);
		private static var _poolIndex:int = 0;
		
		internal var args:Array;
		internal var componentsCollection:Vector.<Component>;
		internal var index:int;
		internal var type:Class;
		internal var recursive:Boolean;
		internal var includeInactive:Boolean;
		
		public function ComponentContext()
		{
			componentsCollection = new Vector.<Component>(1024);
			index = 0;
			recursive = true;
		}
		
		internal static function getInstance():ComponentContext
		{
			if (_poolIndex > 0)
			{
				return POOL[int(--_poolIndex)];
			}
			return new ComponentContext();
		}
		
		internal static function putInstance(value:ComponentContext):void
		{
			POOL[_poolIndex] = value;
			_poolIndex++;
		}
		
		internal function dispose():void
		{
			componentsCollection.length = 0;
			index = 0;
			recursive = true;
			includeInactive = false;
		}
	}
}