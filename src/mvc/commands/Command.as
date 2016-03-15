package mvc.commands
{
    import common.system.Assert;
    import common.system.errors.AbstractMethodError;
    import common.system.IDisposable;
    import common.system.TypeObject;
    
    /**
     * ...
     * @author dorofiy.com
     */
    public class Command extends TypeObject implements IDisposable
    {
        private var _key:Object;
        private var _eventType:Class;
        private var _commandType:Class;
        private var _oneTime:Boolean;
        
        public function Command(key:Object, commandType:Class, eventType:Class, oneTime:Boolean = false)
        {
            _oneTime = oneTime;
            _commandType = commandType;
            _key = key;
            _eventType = eventType;
        }
        
        public function get key():Object
        {
            return _key;
        }
        
        public function get commandType():Class
        {
            return _commandType;
        }
        
        public function get oneTime():Boolean
        {
            return _oneTime;
        }
        
        public function get eventType():Class 
        {
            return _eventType;
        }
        
        /* INTERFACE common.system.IDisposable */
        
        public function dispose():void
        {
            _key = null;
            _commandType = null;
            _oneTime = false;
            _eventType = null;
        }
    }
}