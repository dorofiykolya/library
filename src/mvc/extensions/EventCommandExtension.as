package mvc.extensions
{
	import common.context.extensions.IExtension;
    import common.context.links.Link;
    import mvc.commands.EventCommandMap;
    import mvc.commands.IEventCommandMap;
    import common.context.IContext;
    
    /**
     * ...
     * @author dorofiy.com
     */
    public class EventCommandExtension implements IExtension
    {
        private var _commands:EventCommandMap;
        
        public function EventCommandExtension(commands:EventCommandMap)
        {
            _commands = commands;
        }
        
        /* INTERFACE com.okapp.mvc.extensions.IExtension */
        
        public function extend(context:IContext):void
        {
            context.injector.map(EventCommandMap).toValue(_commands);
            context.injector.map(IEventCommandMap).toValue(_commands);
        }
    }
}