package common.injection.description
{
    import common.injection.IInjector;
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
        private var _type:Class;
        private var _providers:Vector.<TypeInfo>;
        
        private var _currentMeta:MetaData;
        private var _currentInjectionId:String;
        
        public function InjectionType(type:Class)
        {
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
                getInjectMetaData(field);
                if (_currentMeta)
                {
                    _providers[_providers.length] = new TypeInfo(field.type, field.name, _currentInjectionId);
                }
            }
        }
        
        private function extractProperties(type:Type):void
        {
            for each (var property:Property in type.getProperties(Access.READWRITE))
            {
                getInjectMetaData(property);
                if (_currentMeta)
                {
                    _providers[_providers.length] = new TypeInfo(property.type, property.name, _currentInjectionId);
                }
            }
        }
        
        public function apply(injector:IInjector, value:Object):void
        {
            if (_providers.length > 0)
            {
                var provider:IProvider;
                for each (var depency:TypeInfo in _providers)
                {
                    provider = injector.getProvider(depency.type, depency.id);
                    if (provider)
                    {
                        value[depency.name] = provider.apply(injector, depency.type);
                    }
                }
            }
        }
        
        /* INTERFACE common.system.IDisposable */
        
        public function dispose():void
        {
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