package mvc.extensions
{
	import common.context.extensions.IExtension;
    import mvc.bindings.Binding;
    import mvc.bindings.IBinding;
    import common.context.IContext;
    import mvc.processors.BindingProcessor;
    import common.system.IDisposable;
    
    /**
     * ...
     * @author dorofiy.com
     */
    public class BindingExtension implements IExtension, IDisposable
    {
        private var _binding:Binding;
        private var _bindProcessor:BindingProcessor;
        
        public function BindingExtension()
        {
        
        }
        
        /* INTERFACE com.okapp.mvc.extensions.IExtension */
        
        public function extend(context:IContext):void
        {
            _binding = new Binding();
            _bindProcessor = new BindingProcessor(_binding);
            context.injector.map(IBinding).toValue(_binding);
            context.install(_bindProcessor);
        }
        
        /* INTERFACE common.system.IDisposable */
        
        public function dispose():void
        {
            _bindProcessor = null;
            _binding = null;
        }
    }
}