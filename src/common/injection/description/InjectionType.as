package common.injection.description
{
    import common.injection.Injector;
    import common.injection.providers.IProvider;
    import common.injection.tags.Args;
    import common.injection.tags.Tag;
    import common.system.ClassType;
    import common.system.IDisposable;
    import common.system.reflection.Access;
    import common.system.reflection.Argument;
    import common.system.reflection.Field;
    import common.system.reflection.Member;
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
        
        private var _currentMeta:MetaData;
        private var _currentInjectionId:String;
        
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
            var provider:IProvider;
            for each (var field:Field in type.fields)
            {
                getInjectMetaData(field);
                if (_currentMeta)
                {
                    provider = _injector.getProvider(field.type, _currentInjectionId);
                    if (provider)
                    {
                        _providers[_providers.length] = new TypeInfo(provider, field.type, field.name);
                    }
                }
            }
        }
        
        private function extractProperties(type:Type):void
        {
            var provider:IProvider;
            for each (var property:Property in type.getProperties(Access.READWRITE))
            {
                getInjectMetaData(property);
                if (_currentMeta)
                {
                    provider = _injector.getProvider(property.type, _currentInjectionId);
                    if (provider)
                    {
                        _providers[_providers.length] = new TypeInfo(provider, property.type, property.name);
                    }
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
        
        private function getInjectMetaData(member:Member):void
        {
            _currentMeta = null;
            _currentInjectionId = null;
            var metas:Vector.<MetaData> = member.getMetaData(Tag.INJECT);
            if (metas.length > 0)
            {
                for each (var meta:MetaData in metas)
                {
                    for each (var arg:Argument in meta.arguments)
                    {
                        if (arg.name == Args.NAME)
                        {
                            _currentInjectionId = arg.value;
                            _currentMeta = meta;
                        }
                    }
                }
                _currentMeta = metas[0];
            }
        }
    }
}