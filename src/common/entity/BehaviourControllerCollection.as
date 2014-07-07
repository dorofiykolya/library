package common.entity
{
	import common.system.IDisposable;
	import common.system.TypeObject;
	
	/**
	 * ...
	 * @author dorofiy.com
	 */
	internal class BehaviourControllerCollection extends TypeObject implements IDisposable
	{
		private var _collection:Vector.<BehaviourInvoker>;
		
		public function BehaviourControllerCollection()
		{
			_collection = new Vector.<BehaviourInvoker>();
		}
		
		internal function add(value:BehaviourInvoker):void
		{
			_collection[_collection.length] = value;
		}
		
		internal function remove(value:BehaviourInvoker):Boolean
		{
			var index:int = _collection.indexOf(value);
			if (index != -1)
			{
				_collection.splice(index, 1);
				return true;
			}
			return false;
		}
		
		internal function contains(value:BehaviourInvoker):Boolean
		{
			return _collection.indexOf(value) != -1;
		}
		
		internal function get collection():Vector.<BehaviourInvoker>
		{
			return _collection;
		}
		
		/* INTERFACE common.system.IDisposable */
		
		public function dispose():void
		{
			if (_collection.length > 0)
			{
				for each (var item:BehaviourInvoker in _collection)
				{
					item.dispose();
				}
				_collection.length = 0;
			}
		}
	
	}

}