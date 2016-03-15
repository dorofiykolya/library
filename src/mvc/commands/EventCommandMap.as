package mvc.commands
{
    import common.context.IContext;
    import common.events.IEventDispatcher;
    import common.system.IDisposable;
    import common.system.TypeObject;
    import flash.utils.Dictionary;
    
    /**
     * ...
     * @author dorofiy.com
     */
    public class EventCommandMap extends TypeObject implements IEventCommandMap, IDisposable
    {
        private var _map:Dictionary;
        private var _context:IContext;
        private var _eventDispatcher:IEventDispatcher;
        
        public function EventCommandMap(context:IContext, eventDispatcher:IEventDispatcher)
        {
            _map = new Dictionary();
            _context = context;
            _eventDispatcher = eventDispatcher;
        }
        
        public function map(key:Object, eventType:Class = null):ICommandMapper
        {
            return _map[key] || (_map[key] = new CommandMapper(this, _context, key, eventType, _eventDispatcher));
        }
        
        public function unmap(key:Object, eventType:Class = null):ICommanMapperRemove
        {
            return ICommanMapperRemove(map(key, eventType));
        }
        
        /* INTERFACE common.system.IDisposable */
        
        public function dispose():void
        {
            if (_map)
            {
                var disposable:IDisposable;
                for each (var item:CommandMapper in _map) 
                {
                    disposable = item as IDisposable;
                    if (disposable)
                    {
                        disposable.dispose();
                    }
                }
            }
            _map = null;
            _context = null;
            _eventDispatcher = null;
        }
    }
}