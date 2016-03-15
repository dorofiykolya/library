package mvc.extensions
{
    import common.context.IContext;
    import common.injection.IInjector;
    import common.injection.Injector;
    import common.system.TypeObject;
    
    /**
     * ...
     * @author dorofiy.com
     */
    public class InjectionExtension extends TypeObject implements IExtension
    {
        private var _injector:IInjector;
        
        public function InjectionExtension(injector:IInjector)
        {
            _injector = injector;
        }
        
        /* INTERFACE com.okapp.mvc.configurations.IConfiguration */
        
        public function extend(context:IContext):void
        {
            context.injector.map(IInjector).toValue(_injector);
            context.injector.map(Injector).toValue(_injector.injector);
            context.install(_injector);
        }
    }
}