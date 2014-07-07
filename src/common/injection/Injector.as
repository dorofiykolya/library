package common.injection
{
	import common.injection.description.InjectionType;
	import common.injection.maps.IMapping;
	import common.injection.maps.Mapping;
	import common.injection.providers.IProvider;
	import common.system.Cache;
	import common.system.ClassType;
	import common.system.IDisposable;
	import common.system.TypeObject;
	import flash.utils.Dictionary;
	
	/**
	 * ...
	 * @author dorofiy.com
	 */
	public class Injector extends TypeObject implements IDisposable
	{
		private static const INJECTION_TYPE_NAME:String = ClassType.getQualifiedClassName(InjectionType) + "-info";
		
		private var _map:Dictionary;
		private var _provider:Dictionary;
		
		public function Injector()
		{
			_map = new Dictionary();
			_provider = new Dictionary();
		}
		
		public function map(type:Class):IMapping
		{
			return _map[type] || (_map[type] = new Mapping(this, type));
		}
		
		public function unmap(type:Class):void
		{
			var map:IMapping = _map[type];
			if (map)
			{
				map.dispose();
				delete _map[type];
			}
		}
		
		public function mapProvider(type:Class, provider:IProvider):void
		{
			unmapProvider(type);
			_provider[type] = provider;
		}
		
		public function unmapProvider(type:Class):void
		{
			var last:IProvider = _provider[type];
			if (last)
			{
				last.dispose();
			}
		}
		
		public function getProvider(type:Class):IProvider
		{
			return _provider[type];
		}
		
		public function getInjectionType(value:Object):InjectionType
		{
			var type:Class = ClassType.getAsClass(value);
			var injectionDescription:InjectionType = Cache.cache.getStorageValue(INJECTION_TYPE_NAME, type)
			if (injectionDescription == null)
			{
				injectionDescription = new InjectionType(this, type);
				Cache.cache.setStorageValue(INJECTION_TYPE_NAME, type, injectionDescription);
			}
			return injectionDescription;
		}
		
		public function inject(value:Object):void
		{
			getInjectionType(value).apply(value);
		}
		
		/* INTERFACE common.system.IDisposable */
		
		public function dispose():void
		{
			disposeEnumerable(_map);
			disposeEnumerable(_provider);
		}
		
		private function disposeEnumerable(value:Object):void
		{
			if (value)
			{
				for each (var item:IDisposable in value)
				{
					if (item)
					{
						item.dispose();
					}
				}
			}
		}
	}
}