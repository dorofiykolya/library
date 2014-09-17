package common.system.dispatchers
{
    import common.system.Delegate;
    import common.system.IDisposable;
    import common.system.IEquatable;
    import common.system.TypeObject;
    import flash.utils.Dictionary;
    
    /**
     * ...
     * @author dorofiy.com
     */
    public class ListenerMap extends TypeObject implements IEquatable, IDisposable
    {
        private var _data:Dictionary;
        private var _current:Delegate;
        
        public function ListenerMap()
        {
            _data = new Dictionary();
        }
        
        public function add(type:Object, listener:Function):void
        {
            var delegate:Delegate = _data[type] as Delegate;
            if (delegate == null)
            {
                delegate = new Delegate();
                _data[type] = delegate;
            }
            delegate.add(listener);
        }
        
        public function remove(type:Object, listener:Function):void
        {
            var delegate:Delegate = _data[type] as Delegate;
            if (delegate)
            {
                delegate.remove(listener);
            }
        }
        
        public function removeAll():void
        {
            for each (var delegate:Delegate in _data)
            {
                delegate.removeAll();
            }
        }
        
        public function clear():void
        {
            removeAll();
        }
        
        public function has(type:Object):Boolean
        {
            var delegate:Delegate = _data[type] as Delegate;
            return delegate && delegate.count > 0;
        }
        
        public function invoke(type:Object, ... args):void
        {
            var delegate:Delegate = _data[type] as Delegate;
            if (delegate)
            {
                _current = delegate;
                delegate.invoke.apply(null, args);
                _current = null;
            }
        }
        
        public function stop():void
        {
            if (_current)
            {
                _current.stop();
            }
        }
        
        /* INTERFACE common.system.IEquatable */
        
        public function equals(value:Object):Boolean
        {
            return this == value;
        }
        
        /* INTERFACE common.system.IDisposable */
        
        public function dispose():void
        {
            _data = null;
            _current = null;
        }
    }
}