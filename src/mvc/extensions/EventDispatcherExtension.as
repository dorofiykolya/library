package mvc.extensions
{
    import common.context.IContext;
    import common.events.EventDispatcher;
    import common.events.IDispatcher;
    import common.events.IEventDispatcher;
	import common.context.extensions.IExtension;
    
    /**
     * ...
     * @author dorofiy.com
     */
    public class EventDispatcherExtension implements IExtension
    {
        private var _eventDispatcher:EventDispatcher;
        
        public function EventDispatcherExtension(eventDispatcher:EventDispatcher)
        {
            _eventDispatcher = eventDispatcher;
        }
        
        /* INTERFACE com.okapp.mvc.extensions.IExtension */
        
        public function extend(context:IContext):void
        {
            context.injector.map(IEventDispatcher).toValue(_eventDispatcher);
            context.injector.map(IDispatcher).toValue(_eventDispatcher);
            context.injector.map(EventDispatcher).toValue(_eventDispatcher);
        }
    }
}