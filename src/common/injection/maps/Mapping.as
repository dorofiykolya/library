package common.injection.maps
{
	import common.injection.providers.FactoryProvider;
	import common.injection.providers.IProvider;
	import common.injection.providers.SingletonProvider;
	import common.injection.providers.ValueProvider;
	import common.injection.Injector;
	import common.system.TypeObject;
	
	/**
	 * ...
	 * @author dorofiy.com
	 */
	public class Mapping extends TypeObject implements IMapping
	{
		private var _injector:Injector;
		private var _type:Class;
		
		public function Mapping(injector:Injector, type:Class)
		{
			_injector = injector;
			_type = type;
		}
		
		public function get provider():IProvider
		{
			return _injector.getProvider(_type);
		}
		
		public function toFactory(type:Class):void
		{
			toProvider(new FactoryProvider(_type, type));
		}
		
		public function toValue(value:Object):void
		{
			toProvider(new ValueProvider(_type, value));
		}
		
		public function toSingleton(type:Class):void
		{
			toProvider(new SingletonProvider(_type, type));
		}
		
		public function toProvider(provider:IProvider):void
		{
			_injector.mapProvider(_type, provider);
		}
		
		public function asSingleton():void
		{
			toSingleton(_type);
		}
		
		/* INTERFACE common.injection.maps.IMapping */
		
		public function dispose():void 
		{
			_injector = null;
			_type = null;
		}
	}
}