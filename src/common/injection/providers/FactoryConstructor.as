package common.injection.providers 
{
    import common.injection.IInjector;
    import common.injection.tags.Tag;
    import common.system.ClassType;
    import common.system.reflection.MetaData;
    import common.system.reflection.Method;
    import common.system.reflection.Parameter;
    import common.system.Type;
	/**
     * ...
     * @author dorofiy.com
     */
    public class FactoryConstructor 
    {
        private var _constructors:Vector.<Method>;
        
        public function FactoryConstructor(clazz:Class) 
        {
            _constructors = new Vector.<Method>();
            
            var type:Type = ClassType.getInstanceType(clazz);
            for each (var method:Method in type.methods) 
            {
                var metas:Vector.<MetaData> = method.getMetaData(Tag.CONSTRUCTOR);
                if (metas && metas.length != 0)
                {
                    _constructors[_constructors.length] = method;
                }
            } 
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
        
        public function apply(injector:IInjector, result:Object):void 
        {
            for each (var item:Method in _constructors) 
            {
                if (item.parameters.length == 0)
                {
                    result[item.name]();
                }
                else
                {
                    var params:Array = [];
                    var index:int = 0;
                    for each (var param:Parameter in item.parameters)
                    {
                        if (param.optional)
                        {
                            if (!injector.getProvider(param.type))
                            {
                                break;
                            }
                        }
                        params[index] = create(injector, param.type);
                        index++;
                    }
                    result[item.name].apply(null, params);
                }
            }
        }
        
    }

}