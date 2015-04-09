package common.injection.providers
{
    import common.injection.IInjector;
    
    /**
     * ...
     * @author dorofiy.com
     */
    public class SingletonProvider extends Provider
    {
        private var _oneInstance:Boolean;
        private var _instance:Object;
        
        public function SingletonProvider(type:Class, value:Object, oneInstance:Boolean = true)
        {
            super(type, value);
            _oneInstance = oneInstance;
        }
        
        public override function apply(injector:IInjector, type:Class):Object
        {
            if (_instance == null)
            {
                var clazz:Class = Class(_value);
                if (_oneInstance && type != clazz)
                {
                    _instance = injector.getObject(clazz);
                }
                if (_instance == null)
                {
                    var factory:FactoryProvider = new FactoryProvider(clazz, clazz);
                    _instance = factory.apply(injector, clazz);
                    factory.dispose();
                }
            }
            return _instance;
        }
        
        override public function dispose():void 
        {
            _instance = null;
            super.dispose();
        }
    }
}