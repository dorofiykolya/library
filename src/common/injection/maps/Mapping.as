package common.injection.maps
{
	import common.injection.providers.FactoryProvider;
	import common.injection.providers.IProvider;
	import common.injection.providers.SingletonProvider;
	import common.injection.providers.ValueProvider;
	import common.injection.Injector;
	import common.system.ClassType;
	import common.system.TypeObject;
	
	/**
	 * ...
	 * @author dorofiy.com
	 */
	public class Mapping extends TypeObject implements IMapping
	{
		private var _injector:Injector;
		private var _type:Class;
		private var _name:String;
		private var _key:String;
		
		public function Mapping(injector:Injector, type:Class, name:String, key:String)
		{
			_injector = injector;
			_type = type;
			_name = name;
			_key = key;
		}
		
		public function get provider():IProvider
		{
			return _injector.getProviderBy(_key);
		}
		
		public function toFactory(type:Class):void
		{
			if (ClassType.getType(type).isInterface)
			{
				throw new ArgumentError("The constructor of" + type + " is not implemented. Cannot create an interface " + type);
			}
			toProvider(new FactoryProvider(_type, type));
		}
		
		public function toValue(value:Object):void
		{
			toProvider(new ValueProvider(_type, value));
		}
		
		public function toSingleton(type:Class, oneInstance:Boolean = true):void
		{
			if (ClassType.getType(type).isInterface)
			{
				throw new ArgumentError("The constructor of" + type + " is not implemented. Cannot create an interface " + type);
			}
			toProvider(new SingletonProvider(_type, type, oneInstance));
		}
		
		public function toProvider(provider:IProvider):void
		{
			_injector.mapProvider(_type, provider, _name);
		}
		
		public function asSingleton():void
		{
			toSingleton(_type);
		}
		
		public function asFactory():void
		{
			toFactory(_type);
		}
		
		/* INTERFACE common.injection.maps.IMapping */
		
		public function dispose():void
		{
			_injector = null;
			_type = null;
			_name = null;
			_key = null;
		}
	}
}