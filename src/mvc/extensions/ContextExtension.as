package mvc.extensions
{
    import common.context.extensions.IExtension;
    import common.context.IContext;
    import mvc.MVCContext;
    import mvc.processors.ConfigurationProcessor;
    import mvc.processors.ExecuteProcessor;
    import common.system.TypeObject;
    
    /**
     * ...
     * @author dorofiy.com
     */
    public class ContextExtension extends TypeObject implements IExtension
    {
        
        public function ContextExtension()
        {
        
        }
        
        /* INTERFACE com.okapp.mvc.extensions.IExtension */
        
        public function extend(context:IContext):void
        {
            context.injector.map(IContext).toValue(context);
            context.injector.map(MVCContext).toValue(context);
            
            context.install(ConfigurationProcessor);
            context.install(ExecuteProcessor);
        }
    }
}