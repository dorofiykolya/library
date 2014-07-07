package common.injection.description
{
	import common.injection.Injector;
	import common.injection.tags.Tag;
	import common.system.ClassType;
	import common.system.IDisposable;
	import common.system.reflection.Access;
	import common.system.reflection.Field;
	import common.system.reflection.MetaData;
	import common.system.reflection.Property;
	import common.system.Type;
	import common.system.TypeObject;
	
	/**
	 * ...
	 * @author dorofiy.com
	 */
	public class InjectionType extends TypeObject implements IDisposable
	{
		private var _injector:Injector;
		private var _type:Class;
		private var _providers:Vector.<TypeInfo>;
		
		public function InjectionType(injector:Injector, type:Class)
		{
			_injector = injector;
			_type = type;
			_providers = new Vector.<TypeInfo>();
			inspect();
		}
		
		private function inspect():void
		{
			var type:Type = ClassType.getInstanceType(_type);
			extractFields(type);
			extractProperties(type);
		}
		
		private function extractFields(type:Type):void
		{
			for each (var field:Field in type.fields)
			{
				var result:Vector.<MetaData> = field.getMetaData(Tag.INJECT);
				if (result.length > 0)
				{
					_providers[_providers.length] = new TypeInfo(_injector.getProvider(field.type), field.type, field.name);
				}
			}
		}
		
		private function extractProperties(type:Type):void
		{
			for each (var property:Property in type.getProperties(Access.READWRITE))
			{
				var result:Vector.<MetaData> = property.getMetaData(Tag.INJECT);
				if (result.length > 0)
				{
					_providers[_providers.length] = new TypeInfo(_injector.getProvider(property.type), property.type, property.name);
				}
			}
		}
		
		public function apply(value:Object):void
		{
			if (_providers.length > 0)
			{
				for each (var depency:TypeInfo in _providers)
				{
					value[depency.name] = depency.provider.apply(_injector, depency.type);
				}
			}
		}
		
		/* INTERFACE common.system.IDisposable */
		
		public function dispose():void
		{
			_injector = null;
			_type = null;
			if (_providers)
			{
				for each (var item:IDisposable in _providers)
				{
					item.dispose();
				}
				_providers = null;
			}
		}
	}
}