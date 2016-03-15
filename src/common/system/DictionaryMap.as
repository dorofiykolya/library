package common.system 
{
	import flash.utils.Dictionary;
	/**
	 * ...
	 * @author ...
	 */
	public class DictionaryMap extends TypeObject
	{
		
		private var _target:*;
		private var _dictionary:Dictionary;
		private var _parent:DictionaryMap;
		private var _key:Object;
		
		public function DictionaryMap() 
		{
			
		}
		
		public function clear(key:Object):void
		{
			if (_dictionary)
			{
				delete _dictionary[key];
			}
		}
		
		public function map(... keys):DictionaryMap
		{
			var current:DictionaryMap = this;
			for each (var key:Object in keys)
			{
				current = current.getDictionary(key);
			}
			return current;
		}
		
		public function get parent():DictionaryMap
		{
			return _parent;
		}
		
		public function get key():Object
		{
			return _key;
		}
		
		public function get value():*
		{
			return _target;
		}
		
		public function set value(target:*):void
		{
			_target = target;
		}
		
		private function getDictionary(key:Object):DictionaryMap
		{
			_dictionary = _dictionary || new Dictionary();
			var result:DictionaryPath = _dictionary[key];
			if (result == null)
			{
				result = new DictionaryMap();
				result._parent = this;
				result._key = key;
				_dictionary[key] = result;
			}
			return result;
		}
	}

}