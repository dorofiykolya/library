package common.system.dispatchers
{
	import common.system.Delegate;
	import common.system.IDisposable;
	import flash.utils.Dictionary;
	
	/**
	 * ...
	 * @author dorofiy.com
	 */
	public class DelegateMap extends Delegate
	{
		//--------------------------------------------------------------------------
		//     
		//	PRIVATE VARIABLES 
		//     
		//--------------------------------------------------------------------------
		
		private var _map:Dictionary;
		private var _key:Object;
		private var _parent:DelegateMap;
		
		//----------------------------------
		//	CONSTRUCTOR
		//----------------------------------
		
		public function DelegateMap()
		{
		
		}
		
		//--------------------------------------------------------------------------
		//     
		//	PUBLIC PROPERTIES 
		//     
		//--------------------------------------------------------------------------
		
		public function get parent():DelegateMap
		{
			return _parent;
		}
		
		public function get key():Object
		{
			return _key;
		}
		
		//--------------------------------------------------------------------------
		//     
		//	PUBLIC METHODS 
		//     
		//--------------------------------------------------------------------------
		
		public function getMap(key:Object):DelegateMap
		{
			_map ||= new Dictionary();
			var delegate:DelegateMap = _map[key];
			if (delegate == null)
			{
				_map[key] = delegate = new DelegateMap();
				delegate._parent = this;
				delegate._key = key;
			}
			return delegate;
		}
		
		override public function dispose():void
		{
			if (_map)
			{
				for each (var item:DelegateMap in _map)
				{
					item.dispose();
					item._parent = null;
				}
				_map = null;
			}
			super.dispose();
		}
	}
}