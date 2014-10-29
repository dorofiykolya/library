package common.events
{
    import common.system.Cache;
    import common.system.ClassType;
    import common.system.TypeObject;
    import common.system.utils.formatString;
    
    /**
     * ...
     * @author dorofiy.com
     */
    public class Event extends TypeObject
    {
        public static const ADDED:String = "added";
        public static const REMOVED:String = "removed";
        public static const TRIGGERED:String = "triggered";
        public static const RESIZE:String = "resize";
        public static const COMPLETE:String = "complete";
        public static const IO_ERROR:String = "ioError";
        public static const PARSE_ERROR:String = "parseError";
        public static const CHANGE:String = "change";
        public static const CANCEL:String = "cancel";
        public static const OPEN:String = "open";
        public static const CLOSE:String = "close";
        public static const SELECT:String = "select";
        
        private static const TYPE_NAME:String = ClassType.getQualifiedClassName(Event) + "-pool";
        private static const TYPE_NAME_AS:String = ClassType.getQualifiedClassName(Event) + "-type-pool";
        private static const CACHE:Cache = Cache.cache;
        
        private static function get eventPool():Vector.<Event>
        {
            return CACHE[TYPE_NAME] || (CACHE[TYPE_NAME] = new <Event>[]);
        }
        
        private var _target:EventDispatcher;
        private var _currentTarget:EventDispatcher;
        private var _type:Object;
        private var _bubbles:Boolean;
        private var _stopsPropagation:Boolean;
        private var _stopsImmediatePropagation:Boolean;
        private var _data:Object;
        
        public function Event(type:Object, bubbles:Boolean = false, data:Object = null)
        {
            _type = type;
            _bubbles = bubbles;
            _data = data;
        }
        
        public function stopPropagation():void
        {
            _stopsPropagation = true;
        }
        
        public function stopImmediatePropagation():void
        {
            _stopsPropagation = _stopsImmediatePropagation = true;
        }
        
        public override function toString():String
        {
            return formatString("[{0} type=\"{1}\" bubbles={2}]", ClassType.getQualifiedClassName(this).split("::").pop(), _type, _bubbles);
        }
        
        public function get bubbles():Boolean
        {
            return _bubbles;
        }
        
        public function get target():EventDispatcher
        {
            return _target;
        }
        
        public function get currentTarget():EventDispatcher
        {
            return _currentTarget;
        }
        
        public function get type():Object
        {
            return _type;
        }
        
        public function get data():Object
        {
            return _data;
        }
        
        internal function setTarget(value:EventDispatcher):void
        {
            _target = value;
        }
        
        internal function setCurrentTarget(value:EventDispatcher):void
        {
            _currentTarget = value;
        }
        
        internal function setData(value:Object):void
        {
            _data = value;
        }
        
        internal function get stopsPropagation():Boolean
        {
            return _stopsPropagation;
        }
        
        internal function get stopsImmediatePropagation():Boolean
        {
            return _stopsImmediatePropagation;
        }
        
        internal function reinitializeEvent(type:Object, bubbles:Boolean, data:Object, args:Array):Event
        {
            _type = type;
            _bubbles = bubbles;
            _data = data;
            _target = _currentTarget = null;
            _stopsPropagation = _stopsImmediatePropagation = false;
            initializeEvent.apply(null, args);
            return this;
        }
        
        public static function fromPool(type:Object, bubbles:Boolean = false, data:Object = null):Event
        {
            if (eventPool.length)
                return eventPool.pop().reinitializeEvent(type, bubbles, data, null);
            else
                return new Event(type).reinitializeEvent(type, bubbles, data, null);
        }
        
        public static function toPool(event:Event):void
        {
            event._data = event._target = event._currentTarget = null;
            eventPool[eventPool.length] = event;
        }
        
        public static function fromPoolAs(typeClass:Class, type:Object, bubbles:Boolean, data:Object = null, args:Array = null):Event
        {
            var collection:Vector.<Event> = Cache.cache.getStorageValue(TYPE_NAME_AS, typeClass);
            if (collection == null || collection.length == 0)
            {
                return new typeClass(type).reinitializeEvent(type, bubbles, data, args);
            }
            return collection.pop().reinitializeEvent(type, bubbles, data, args);
        }
        
        public static function toPoolAs(event:Event):void
        {
            var type:Class = ClassType.getClass(event);
            var collection:Vector.<Event> = Cache.cache.getStorageValue(TYPE_NAME_AS, type);
            if (collection == null)
            {
                collection = new Vector.<Event>();
                Cache.cache.setStorageValue(TYPE_NAME_AS, type, collection);
            }
            collection[collection.length] = event;
        }
        
        internal function reset(type:Object, bubbles:Boolean = false, data:Object = null):Event
        {
            _type = type;
            _bubbles = bubbles;
            _data = data;
            _target = _currentTarget = null;
            _stopsPropagation = _stopsImmediatePropagation = false;
            return this;
        }
        
        protected function initializeEvent(... args):Event
        {
            return this;
        }
    }
}