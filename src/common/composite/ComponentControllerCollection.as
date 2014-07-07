package common.composite
{
	import common.system.IDisposable;
	import common.system.TypeObject;
	
	/**
	 * ...
	 * @author dorofiy.com
	 */
	internal class ComponentControllerCollection extends TypeObject implements IDisposable
	{
		private var _collection:Vector.<ComponentBehaviour>;
		
		public function ComponentControllerCollection()
		{
			_collection = new Vector.<ComponentBehaviour>();
		}
		
		internal function add(value:ComponentBehaviour):void
		{
			_collection[_collection.length] = value;
		}
		
		internal function remove(value:ComponentBehaviour):Boolean
		{
			var index:int = _collection.indexOf(value);
			if (index != -1)
			{
				_collection.splice(index, 1);
				return true;
			}
			return false;
		}
		
		internal function contains(value:ComponentBehaviour):Boolean
		{
			return _collection.indexOf(value) != -1;
		}
		
		internal function get collection():Vector.<ComponentBehaviour>
		{
			return _collection;
		}
		
		/* INTERFACE common.system.IDisposable */
		
		public function dispose():void
		{
			if (_collection.length > 0)
			{
				for each (var item:ComponentBehaviour in _collection)
				{
					item.dispose();
				}
				_collection.length = 0;
			}
		}
	}
}