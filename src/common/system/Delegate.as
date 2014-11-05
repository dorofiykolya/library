package common.system
{
	
	/**
	 * ...
	 * @author dorofiy.com
	 */
	public class Delegate extends TypeObject implements IDisposable, ICloneable, IDelegate
	{
		//--------------------------------------------------------------------------
		//     
		//	PRIVATE VARIABLES 
		//     
		//--------------------------------------------------------------------------
		
		private var _collection:Vector.<Function>;
		private var _stoped:Boolean;
		private var _count:int;
		
		//----------------------------------
		//	CONSTRUCTOR
		//----------------------------------
		
		public function Delegate()
		{
			_collection = new Vector.<Function>();
			_stoped = false;
			_count = 0;
		}
		
		//--------------------------------------------------------------------------
		//     
		//	PUBLIC STATIC METHODS
		//     
		//--------------------------------------------------------------------------
		
		/**
		 *
		 * @param	handler
		 * @param	... args
		 * @return
		 */
		public static function wrap(handler:Function, ... args):Function
		{
			return function(... innerArgs):void
			{
				var handlerArgs:Array = [];
				if (innerArgs != null)
				{
					handlerArgs = innerArgs;
				}
				if (args != null)
				{
					handlerArgs = handlerArgs.concat(args);
				}
				handler.apply(this, handlerArgs);
			};
		}
		
		//--------------------------------------------------------------------------
		//     
		//	PUBLIC PROPERTIES 
		//     
		//--------------------------------------------------------------------------
		
		/**
		 *
		 */
		public function get count():int
		{
			return _count;
		}
		
		//--------------------------------------------------------------------------
		//     
		//	PUBLIC METHODS 
		//     
		//--------------------------------------------------------------------------
		
		/**
		 *
		 * @param	listener
		 * @return
		 */
		public function has(listener:Function):Boolean
		{
			return _collection.indexOf(listener) != -1;
		}
		
		/**
		 *
		 */
		public function removeAll():void
		{
			_collection.length = 0;
			_count = 0;
		}
		
		/**
		 *
		 * @param	... params
		 */
		public function invoke(... params):void
		{
			var len:int = _collection.length;
			if (len == 0)
			{
				_stoped = false;
				return;
			}
			var current:Function;
			var index:int;
			
			for (var i:int = 0; i < len; i++)
			{
				if (_count <= 0 || _stoped)
				{
					_stoped = false;
					return;
				}
				current = _collection[i];
				if (current as Function)
				{
					if (index != i)
					{
						_collection[index] = current;
						_collection[i] = null;
					}
					if (params.length == 0 || current.length == 0)
					{
						current();
					}
					else
					{
						current.apply(null, params);
					}
					index++;
				}
			}
			if (index != i)
			{
				len = _collection.length; // count might have changed!
				while (i < len)
				{
					_collection[index++] = _collection[i++];
				}
				
				_collection.length = index;
			}
			_stoped = false;
		}
		
		/**
		 *
		 */
		public function stop():void
		{
			_stoped = true;
		}
		
		//--------------------------------------------------------------------------
		//     
		//	INTERFACE SECTION 
		//     
		//--------------------------------------------------------------------------
		
		/* INTERFACE common.system.IDelegate */
		
		/**
		 *
		 * @param	listener
		 */
		public function add(listener:Function):void
		{
			var index:int = _collection.indexOf(listener);
			if (index == -1)
			{
				_collection[_collection.length] = listener;
				_count++;
			}
			else
			{
				if (_count == 1)
				{
					return;
				}
				_collection[index] = null;
				_collection[_collection.length] = listener;
			}
		}
		
		/**
		 *
		 * @param	listener
		 */
		public function remove(listener:Function):void
		{
			var i:int = _collection.indexOf(listener);
			if (i == -1)
			{
				return;
			}
			_collection[i] = null;
			_count--;
		}
		
		/* INTERFACE common.system.ICloneable */
		
		/**
		 *
		 * @return
		 */
		public function clone():Object
		{
			var target:Delegate = new Delegate();
			target._collection = _collection.slice();
			return target;
		}
		
		/* INTERFACE common.system.IDisposable */
		
		/**
		 *
		 */
		public function dispose():void
		{
			_collection.length = 0;
			_stoped = false;
			_count = 0;
		}
	}
}