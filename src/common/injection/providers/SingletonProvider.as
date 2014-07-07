package common.injection.providers
{
	import common.injection.Injector;
	
	/**
	 * ...
	 * @author dorofiy.com
	 */
	public class SingletonProvider extends Provider
	{
		
		public function SingletonProvider(type:Class, value:Object)
		{
			super(type, value);
		}
		
		public override function apply(injector:Injector, type:Class):Object
		{
			if (_value is Class)
			{
				_value = new _value;
			}
			return _value;
		}
	}
}