package common.system.utils
{
	import common.system.ClassType;
	import common.system.IDisposable;
	import common.system.TypeObject;
	import flash.utils.Dictionary;
	
	/**
	 * ...
	 * @author dorofiy.com
	 */
	public class PoolFactory extends TypeObject implements IDisposable
	{
		private var _dictionary:Dictionary;
		
		public function PoolFactory()
		{
		
		}
		
		public function getObject(type:Class):IPoolable
		{
			_dictionary ||= new Dictionary();
			var info:PoolInfo = _dictionary[type];
			if (info && info.index > 0)
			{
				info.index--;
				var target:IPoolable = info[info.index];
				info[info.index] = null;
				target.reinitialize();
				return target;
			}
			return new type();
		}
		
		public function returnObject(instance:IPoolable):void
		{
			if (instance)
			{
				_dictionary ||= new Dictionary();
				var ref:PoolRef = instance.poolRef;
				if (!ref.isPreDisposed && !ref.isDisposed)
				{
					ref.isPreDisposed = true;
					ref.isDisposed = true;
					ref.targetType ||= ClassType.getClass(instance);
					ref.pool = this;
					
					var info:PoolInfo = _dictionary[ref.targetType];
					if (info == null)
					{
						info = new PoolInfo();
						_dictionary[ref.targetType] = info;
					}
					info.collection[info.index] = instance;
					info.index++;
				}
			}
		}
		
		public function clear():void
		{
			_dictionary = new Dictionary();
		}
		
		/* INTERFACE common.system.IDisposable */
		
		public function dispose():void
		{
			_dictionary = null;
		}
	}
}

class PoolInfo
{
	public var collection:Vector.<Object>;
	public var index:int;
	
	public function PoolInfo()
	{
		collection = new Vector.<Object>(64);
	}
}