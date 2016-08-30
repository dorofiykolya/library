package common.system
{
	import common.system.collection.Enumerator;
	import common.system.collection.IEnumerable;
	import common.system.collection.IEnumerator;
	import flash.utils.Dictionary;
	
	/**
	 * ...
	 * @author dorofiy.com
	 */
	public class DictionaryMap extends TypeObject implements IEnumerable
	{
		private var _target:*;
		private var _dictionary:Dictionary;
		private var _parent:DictionaryMap;
		private var _key:Object;
		
		public function DictionaryMap()
		{
		
		}
		
		public function clear(key:Object = null):void
		{
			if (_dictionary)
			{
				if (key != null)
				{
					delete _dictionary[key];
				}
				else
				{
					_dictionary = new Dictionary();
				}
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
		
		/**
		 * common.system.collection.KeyValuePair
		 * @return
		 */
		public function getEnumerator():IEnumerator
		{
			return new DictionaryMapEnumerator(_dictionary);
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
			var result:DictionaryMap = _dictionary[key];
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

import common.system.collection.IEnumerator;
import common.system.collection.KeyValuePair;
import flash.utils.Dictionary;

class DictionaryMapEnumerator implements IEnumerator
{
	private var _collection:Vector.<KeyValuePair>;
	private var _position:int;
	private var _elements:int;
	
	public function DictionaryMapEnumerator(dictionary:Dictionary)
	{
		_collection = new Vector.<KeyValuePair>();
		for (var prop:Object in dictionary)
		{
			_collection[_collection.length] = new KeyValuePair(prop, dictionary[prop]);
		}
		_elements = _collection.length;
		_collection.fixed = true;
		_position = -1;
	}
	
	public function get current():Object
	{
		if (_position == -1)
		{
			return null;
		}
		return _collection[_position];
	}
	
	public function moveNext():Boolean
	{
		if (_elements == 0)
		{
			return false;
		}
		if (_position >= _elements - 1)
		{
			return false;
		}
		_position++;
		return true;
	}
	
	public function reset():void
	{
		_position = -1;
	}
}