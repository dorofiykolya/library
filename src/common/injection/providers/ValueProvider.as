package common.injection.providers
{
    import common.injection.IInjector;
    
    /**
     * ...
     * @author dorofiy.com
     */
    public class ValueProvider extends Provider
    {
        public function ValueProvider(type:Class, value:Object)
        {
            super(type, value);
        }
        
        /* INTERFACE common.injection.depends.IDependency */
        
        public override function apply(injector:IInjector, type:Class):Object
        {
            return _value;
        }
    }
}