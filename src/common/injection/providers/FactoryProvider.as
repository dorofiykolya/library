package common.injection.providers
{
    import common.injection.IInjector;
    import common.system.Cache;
    import common.system.ClassType;
    import common.system.reflection.Parameter;
    import common.system.Type;
    
    /**
     * ...
     * @author dorofiy.com
     */
    public class FactoryProvider extends Provider
    {
        private static const INJECTION_TYPE_NAME:String = ClassType.getQualifiedClassName(FactoryProvider) + "-info";
        
        private var _factory:FactoryConstructor;
        
        public function FactoryProvider(type:Class, value:Object)
        {
            super(type, value);
            initializeCache();
        }
        
        private function initializeCache():void
        {
            var clazz:Class = Class(_value);
            _factory = Cache.cache.getStorageValue(INJECTION_TYPE_NAME, clazz);
            if (_factory == null)
            {
                _factory = new FactoryConstructor(clazz);
                Cache.cache.setStorageValue(INJECTION_TYPE_NAME, clazz, _factory);
            }
        }
        
        /* INTERFACE common.injection.depends.IDependency */
        
        public override function apply(injector:IInjector, type:Class):Object
        {
            var result:Object = createInstance(injector, ClassType.getInstanceType(type));
            if (result)
            {
                injector.inject(result);
                _factory.apply(injector, result);
            }
            return result;
        }
        
        private function create(injector:IInjector, type:Class):Object
        {
            var provider:IProvider = injector.getProvider(type);
            if (provider)
            {
                return provider.apply(injector, type);
            }
            var result:Object = createInstance(injector, ClassType.getInstanceType(type));
            injector.inject(result);
            return result;
        }
        
        private function createInstance(injector:IInjector, type:Type):Object
        {
            var result:Object;
            if (type.constructorInfo.parameters.length == 0)
            {
                result = type.newInstance();
            }
            else
            {
                var params:Array = [];
                for each (var param:Parameter in type.constructorInfo.parameters)
                {
                    if (param.optional)
                    {
                        if (!injector.getProvider(param.type))
                        {
                            break;
                        }
                    }
                    params.push(create(injector, param.type));
                }
                result = ClassType.newInstanceWith(type.type, params);
            }
            return result;
        }
    }
}