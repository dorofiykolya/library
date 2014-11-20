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
    public class Injector extends TypeObject implements IInjector, IDisposable
    {
        private static const INJECTION_TYPE_NAME:String = ClassType.getQualifiedClassName(InjectionType) + "-info";
        
        private var _map:Dictionary;
        private var _provider:Dictionary;
        private var _parent:IInjector;
        
        public function Injector()
        {
            _map = new Dictionary();
            _provider = new Dictionary();
        }
        
        public function map(type:Class, name:String = null):IMapping
        {
            var key:String = getKey(type, name);
            return _map[key] || (_map[key] = new Mapping(this, type, name, key));
        }
        
        public function unmap(type:Class, name:String = null):void
        {
            var key:String = getKey(type, name);
            var map:IMapping = _map[key];
            if (map)
            {
                unmapProvider(type, name);
                map.dispose();
                delete _map[key];
            }
        }
        
        public function mapProvider(type:Class, provider:IProvider, name:String = null):void
        {
            var key:String = getKey(type, name);
            unmapProvider(type, name);
            _provider[key] = provider;
        }
        
        public function unmapProvider(type:Class, name:String = null):void
        {
            var key:String = getKey(type, name);
            var last:IProvider = _provider[key];
            if (last)
            {
                last.dispose();
                delete _provider[key];
            }
        }
        
        public function getProviderBy(key:String):IProvider
        {
            return _provider[key];
        }
        
        public function getProvider(type:Class, name:String = null):IProvider
        {
            var result:IProvider = _provider[key];
            if(result == null && _parent)
            {
                result = _parent.getProvider(type, name);
            }
            return result;
        }
        
        public function getInjectionType(value:Object):InjectionType
        {
            var type:Class = ClassType.getAsClass(value);
            var injectionDescription:InjectionType = Cache.cache.getStorageValue(INJECTION_TYPE_NAME, type)
            if (injectionDescription == null)
            {
                injectionDescription = new InjectionType(type);
                Cache.cache.setStorageValue(INJECTION_TYPE_NAME, type, injectionDescription);
            }
            return injectionDescription;
        }
        
        public function inject(value:Object):void
        {
            if (_parent)
            {
                _parent.inject(value);
            }
            getInjectionType(value).apply(this, value);
        }
        
        public function getObject(type:Class, name:String = null):Object
        {
            var provider:IProvider = getProvider(type, name)
            if (provider)
            {
                return provider.apply(this, type);
            }
            return null;
        }
        
        /* INTERFACE common.system.IDisposable */
        
        public function dispose():void
        {
            disposeEnumerable(_map);
            disposeEnumerable(_provider);
        }
        
        public function get parent():IInjector 
        {
            return _parent;
        }
        
        public function set parent(value:IInjector):void 
        {
            _parent = value;
        }
        
        private function getKey(type:Class, name:String):String
        {
            if (name)
            {
                return ClassType.getQualifiedClassName(type) + "|" + name;
            }
            return ClassType.getQualifiedClassName(type);
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