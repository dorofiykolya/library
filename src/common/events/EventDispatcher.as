package common.events
{
    import common.composite.Component;
    import common.system.IDisposable;
    import common.system.TypeObject;
    import flash.utils.Dictionary;
    
    /**
     * ...
     * @author dorofiy.com
     */
    public class EventDispatcher extends TypeObject implements IEventDispatcher, IDisposable
    {
        private static var _bubbleChains:Vector.<Vector.<EventDispatcher>> = new <Vector.<EventDispatcher>>[];
        
        private var _eventListeners:Dictionary;
        
        public function EventDispatcher()
        {
        
        }
        
        public function addEventListener(type:Object, listener:Function):void
        {
            if (_eventListeners == null)
            {
                _eventListeners = new Dictionary();
            }
            
            var listeners:Vector.<Function> = _eventListeners[type] as Vector.<Function>;
            if (listeners == null)
            {
                _eventListeners[type] = new <Function>[listener];
            }
            else if (listeners.indexOf(listener) == -1)
            {
                listeners[listeners.length] = listener;
            }
        }
        
        public function removeEventListener(type:Object, listener:Function):void
        {
            if (_eventListeners)
            {
                var listeners:Vector.<Function> = _eventListeners[type] as Vector.<Function>;
                var numListeners:int = listeners ? listeners.length : 0;
                
                if (numListeners > 0)
                {
                    var index:int = 0;
                    var restListeners:Vector.<Function> = new Vector.<Function>(numListeners - 1);
                    
                    for (var i:int = 0; i < numListeners; ++i)
                    {
                        var otherListener:Function = listeners[i];
                        if (otherListener != listener)
                        {
                            restListeners[int(index++)] = otherListener;
                        }
                    }
                    
                    _eventListeners[type] = restListeners;
                }
            }
        }
        
        public function removeEventListeners(type:Object = null):void
        {
            if (type && _eventListeners)
            {
                delete _eventListeners[type];
            }
            else
            {
                _eventListeners = null;
            }
        }
        
        public function dispatchEvent(event:Event):void
        {
            var bubbles:Boolean = event.bubbles;
            
            if (!bubbles && (_eventListeners == null || !(event.type in _eventListeners)))
            {
                return;
            }
            
            var previousTarget:EventDispatcher = event.target;
            event.setTarget(this);
            
            if (bubbles && this is Component)
            {
                bubbleEvent(event);
            }
            else
            {
                invokeEvent(event);
            }
            if (previousTarget)
            {
                event.setTarget(previousTarget);
            }
        }
        
        internal function invokeEvent(event:Event):Boolean
        {
            var listeners:Vector.<Function> = _eventListeners ? _eventListeners[event.type] as Vector.<Function> : null;
            var numListeners:int = listeners == null ? 0 : listeners.length;
            
            if (numListeners)
            {
                event.setCurrentTarget(this);
                
                for (var i:int = 0; i < numListeners; ++i)
                {
                    var listener:Function = listeners[i] as Function;
                    var numArgs:int = listener.length;
                    
                    if (numArgs == 0)
                    {
                        listener();
                    }
                    else if (numArgs == 1)
                    {
                        listener(event);
                    }
                    else
                    {
                        listener(event, event.data);
                    }
                    
                    if (event.stopsImmediatePropagation)
                    {
                        return true;
                    }
                }
                
                return event.stopsPropagation;
            }
            return false;
        }
        
        internal function bubbleEvent(event:Event):void
        {
            var chain:Vector.<EventDispatcher>;
            var element:Component = this as Component;
            var length:int = 1;
            
            if (_bubbleChains.length > 0)
            {
                chain = _bubbleChains.pop();
                chain[0] = element;
            }
            else
            {
                chain = new <EventDispatcher>[element];
            }
            
            while ((element = element.parent) != null)
            {
                chain[int(length++)] = element;
            }
            
            for (var i:int = 0; i < length; ++i)
            {
                var stopPropagation:Boolean = chain[i].invokeEvent(event);
                if (stopPropagation)
                {
                    break;
                }
            }
            
            chain.length = 0;
            _bubbleChains[_bubbleChains.length] = chain;
        }
        
        public function dispatchEventWith(type:Object, bubbles:Boolean = false, data:Object = null):void
        {
            if (bubbles || hasEventListener(type))
            {
                var event:Event = Event.fromPool(type, bubbles, data);
                dispatchEvent(event);
                if (!event._disposed)
                {
                    event.dispose();
                }
                Event.toPool(event);
            }
        }
        
        public function dispatchEventAs(typeClass:Class, type:Object, bubbles:Boolean = false, data:Object = null, ... args):void
        {
            if (bubbles || hasEventListener(type))
            {
                var event:Event = Event.fromPoolAs(typeClass, type, bubbles, data, args);
                dispatchEvent(event);
                if (!event._disposed)
                {
                    event.dispose();
                }
                Event.toPoolAs(event);
            }
        }
        
        public function hasEventListener(type:Object, listener:Function = null):Boolean
        {
            var listeners:Vector.<Function> = _eventListeners ? _eventListeners[type] : null;
            if (listeners)
            {
                if (listeners.length != 0)
                {
                    if (Boolean(listener))
                    {
                        return listeners.indexOf(listener) != -1;
                    }
                    return true;
                }
            }
            return false;
        }
        
        /* INTERFACE common.system.IDisposable */
        
        public function dispose():void
        {
            removeEventListeners();
        }
    }
}