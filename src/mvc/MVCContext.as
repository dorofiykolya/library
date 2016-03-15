package mvc
{
	import common.context.Context;
	import common.context.IContext;
    import mvc.commands.Command;
    import mvc.commands.EventCommandMap;
    import mvc.commands.IEventCommandMap;
    import mvc.extensions.BindingExtension;
    import mvc.extensions.ContextExtension;
    import mvc.extensions.EventCommandExtension;
    import mvc.extensions.EventDispatcherExtension;
    import common.events.EventDispatcher;
    import common.events.IDispatcher;
    import common.system.ITypeObject;
    
    public class MVCContext extends Context implements ITypeObject, IContext
    {
        private var _commands:EventCommandMap;
        private var _eventDispatcher:EventDispatcher;
        
        public function MVCContext(parent:IContext = null)
        {
            super(parent);
            
            _eventDispatcher = new EventDispatcher();
            _commands = new EventCommandMap(this, _eventDispatcher);
            
            injector.map(EventDispatcher).toValue(_eventDispatcher);
            injector.map(EventCommandMap).toValue(_commands);
            
            install(BindingExtension);
            install(EventDispatcherExtension);
            install(EventCommandExtension);
            install(ContextExtension);
        }
        
        /* INTERFACE com.okapp.mvc.IContext */ /**
         *
         * @param	... components - (extensions, processors, configurations, beans, etc)
         * @return
         */
        public override function install(... components):IContext
        {
            var index:int = 0;
            var extens:Array = components.slice();
            for each (var value:Object in components)
            {
                if (value is Command)
                {
                    var command:Command = value as Command;
                    _commands.map(command.key, command.eventType).add(command.commandType, command.oneTime);
                    command.dispose();
                }
                else
                {
                    extens[index] = value;
                    index++;
                }
            }
            extens.length = index;
            super.install.apply(null, extens);
            return this;
        }
        
        public function get commands():IEventCommandMap
        {
            return _commands;
        }
        
        public function get dispatcher():IDispatcher
        {
            return _eventDispatcher;
        }
    }
}
