package common.injection.providers
{
    import common.injection.Injector;
    import common.system.TypeObject;
    
    /**
     * ...
     * @author dorofiy.com
     */
    public class FactoryProvider extends Provider
    {
        public function FactoryProvider(type:Class, value:Object)
        {
            super(type, value);
        }
        
        /* INTERFACE common.injection.depends.IDependency */
        
        public override function apply(injector:Injector, type:Class):Object
        {
            var result:Object = new type();
            injector.inject(result);
            return result;
        }
    }
}