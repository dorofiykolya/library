package common.context.links
{
    import common.system.Assert;
    import common.system.ClassType;
    import common.system.IDisposable;
    import common.system.Type;
    import common.system.TypeObject;
    
    public class Link extends TypeObject implements IDisposable
    {
        internal var _instance:Object;
        private var _instanceType:Type;
        private var _name:String;
        private var _type:Class;
        private var _api:Class;
        
        public function Link(impl:Object, api:Class = null, name:String = null)
        {
            _instanceType = ClassType.getInstanceType(impl);
            _type = _instanceType.constructorClass;
            _instance = impl;
            _name = name;
            _api = api == null ? _type : api;
            Assert.isTrue(_instanceType.isInstanceOf(_api), "api argument:" + api + " is not of type:\"" + impl + "\"");
        }
        
        /* INTERFACE common.system.IDisposable */
        
        public function dispose():void
        {
            if (_instance)
            {
                if (_instance is IDisposable)
                {
                    IDisposable(_instance).dispose();
                }
                _instance = null;
                _name = null;
                _type = null;
                _api = null;
                _instanceType = null;
            }
        }
        
        public function get name():String
        {
            return _name;
        }
        
        public function get instance():Object
        {
            return _instance;
        }
        
        public function get instanceType():Type
        {
            return _instanceType;
        }
        
        public function get type():Class
        {
            return _type;
        }
        
        public function get api():Class
        {
            return _api;
        }
    }
}
