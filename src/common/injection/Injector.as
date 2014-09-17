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
        
        private function getKey(type:Class, name:String):String
        {
            if (name)
            {
                return ClassType.getQualifiedClassName(type) + "|" + name;
            }
            return ClassType.getQualifiedClassName(type);
        }
        
        public function map(type:Class, name:String = null):IMapping
        {
            var key:String = getKey(type, name);
            return _map[key] || (_map[key] = new Mapping(this, type, name, key));
        }
        
        public function unmap(type:Class, id:String = null):void
        {
            var key:String = getKey(type, id);
            var map:IMapping = _map[key];
            if (map)
            {
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
            }
        }
        
        public function getProviderBy(key:String):IProvider
        {
            return _provider[key];
        }
        
        public function getProvider(type:Class, name:String = null):IProvider
        {
            var key:String = getKey(type, name);
            return _provider[key];
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