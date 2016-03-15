package mvc.commands
{
    import common.context.IContext;
    import common.events.IEventDispatcher;
    import common.system.ClassType;
    import common.system.IDisposable;
    import common.system.TypeObject;
    import flash.utils.Dictionary;
    
    /**
     * ...
     * @author dorofiy.com
     */
    public class CommandMapper extends TypeObject implements ICommandMapper, ICommanMapperRemove, IDisposable
    {
        private var _key:Object;
        private var _type:Class;
        private var _eventDispatcher:IEventDispatcher;
        private var _collection:Vector.<Class>;
        private var _context:IContext;
        private var _oneTimeByType:Dictionary;
        private var _eventCommandMap:IEventCommandMap;
        
        public function CommandMapper(eventCommandMap:IEventCommandMap, context:IContext, key:Object, eventType:Class, eventDispatcher:IEventDispatcher)
        {
            _eventCommandMap = eventCommandMap;
            _key = key;
            _type = eventType;
            _eventDispatcher = eventDispatcher;
            _context = context;
            _collection = new Vector.<Class>();
            _oneTimeByType = new Dictionary();
            _eventDispatcher.addEventListener(key, onEventDispatcherHandler);
        }
        
        private function onEventDispatcherHandler(event:Object = null):void
        {
            executeCommand(event);
        }
		
		protected function executeCommand(event:Object = null)
		{
			if (_type == null || event is _type)
            {
                var command:ICommand;
                var disposable:IDisposable;
                var type:Class = ClassType.getAsClass(event);
                for each (var commandType:Class in _collection.slice())
                {
                    command = CommandFactory.fromPool(commandType);
                    if (command)
                    {
                        _context.injector.map(type).toValue(event);
                        _context.injector.inject(command);
                        command.execute();
                        _context.injector.unmap(type);
                        disposable = command as IDisposable;
                        if (disposable)
                        {
                            disposable.dispose();
                        }
                        CommandFactory.toPool(command);
                        if (commandType in _oneTimeByType)
                        {
                            _eventCommandMap.unmap(_key, _type).remove(commandType);
                        }
                    }
                }
            }
		}
        
        /* INTERFACE com.okapp.mvc.commands.ICommanMapperRemove */
        
        public function remove(commandType:Class):void
        {
            var index:int = _collection.indexOf(commandType);
            if (index != -1)
            {
                _collection.splice(index, 1);
                delete _oneTimeByType[commandType];
            }
        }
        
        /* INTERFACE com.okapp.mvc.commands.ICommandMapper */
        
        public function add(commandType:Class, oneTime:Boolean = false):void
        {
            if (_collection.indexOf(commandType) == -1)
            {
                _collection[_collection.length] = commandType;
                if (oneTime)
                {
                    _oneTimeByType[commandType] = true;
                }
            }
        }
        
        public function has(type:Class = null):Boolean
        {
            if (type == null)
            {
                return _collection.length > 0;
            }
            var i:int = 0;
            var len:int = _collection.length;
            for (; i < len; i++)
            {
                if (_collection[i] is type)
                {
                    return true;
                }
            }
            return false;
        }
        
        /* INTERFACE common.system.IDisposable */
        
        public function dispose():void
        {
            _key = null;
            _type = null;
            _context = null;
            _oneTimeByType = null;
            _eventCommandMap = null;
            if (_eventDispatcher)
            {
                _eventDispatcher.removeEventListener(_key, onEventDispatcherHandler);
                _eventDispatcher = null;
            }
            if (_collection)
            {
                var disposable:IDisposable;
                for each (var item:ICommand in _collection)
                {
                    disposable = item as IDisposable;
                    if (disposable)
                    {
                        disposable.dispose();
                    }
                }
                _collection = null;
            }
        }
    }
}