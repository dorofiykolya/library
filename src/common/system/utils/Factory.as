package common.system.utils
{
    import common.system.ClassType;
    import common.system.IDisposable;
    import common.system.TypeObject;
    import flash.utils.Dictionary;
    
    /**
     * ...
     * @author dorofiy.com
     */
    public class Factory extends TypeObject implements IDisposable
    {
        private var _dictionary:Dictionary;
        
        public function Factory()
        {
            
        }
        
        public function newInstance(type:Class, ...constructorArgs):Object
        {
            return ClassType.newInstanceWith(type, constructorArgs);
        }
        
        public function getInstance(type:Class, ...constructorArgs):Object
        {
            _dictionary ||= new Dictionary();
            var collection:Vector.<Object> = _dictionary[type];
            if (collection && collection.length != 0)
            {
                return collection.pop();
            }
            return ClassType.newInstanceWith(type, constructorArgs);
        }
        
        public function returnInstance(instance:Object):void
        {
            if (instance && !(instance is Class))
            {
                _dictionary ||= new Dictionary();
                var type:Class = ClassType.getAsClass(instance);
                var collection:Vector.<Object> = _dictionary[type];
                if (collection == null)
                {
                    _dictionary[type] = collection = new Vector.<Object>();
                }
                collection[collection.length] = instance;
            }
        }
        
        /* INTERFACE common.system.IDisposable */
        
        public function dispose():void
        {
            _dictionary = null;
        }
    }
}