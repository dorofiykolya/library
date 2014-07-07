package common.system.collection
{
	import common.system.IDisposable;
	import common.system.TypeObject;
	
	/**
	 * ...
	 * @author dorofiy.com
	 */
	public class Enumerator extends TypeObject implements IEnumerator, IDisposable
	{
		//--------------------------------------------------------------------------
		//     
		//	PRIVATE VARIABLES 
		//     
		//--------------------------------------------------------------------------
		
		private var _position:int;
		private var _collection:Vector.<Object>;
		private var _elements:int;
		
		//----------------------------------
		//	CONSTRUCTOR
		//----------------------------------
		
		public function Enumerator(value:Object)
		{
			var valueLength:int = "length" in value ? value.length : 0;
			
			_position = -1;
			_collection = new Vector.<Object>(valueLength);
			
			var index:int = 0;
			for each (var item:Object in value)
			{
				_collection[index] = item;
				index++;
			}
			_elements = index;
			_collection.length = index;
			_collection.fixed = true;
		}
		
		//--------------------------------------------------------------------------
		//     
		//	PUBLIC METHODS 
		//     
		//--------------------------------------------------------------------------
		
		/* INTERFACE common.system.collection.IEnumerator */
		
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
		
		/* INTERFACE common.system.IDisposable */
		
		public function dispose():void
		{
			if (_collection)
			{
				_collection.length = 0;
				_collection = null;
			}
		}
	}
}