package common.composite
{
    import common.system.ClassType;
    import common.system.IDisposable;
    import common.system.TypeObject;
    
    /**
     * ...
     * @author dorofiy.com
     */
    public class ComponentInvoker extends ComponentBehaviour
    {
        //--------------------------------------------------------------------------
        //     
        //	PRIVATE VARIABLES 
        //     
        //--------------------------------------------------------------------------
        
        private var _methodName:String;
        private var _type:Class;
        private var _includeInactive:Boolean;
        
        //----------------------------------
        //	CONSTRUCTOR
        //----------------------------------
        
        public function ComponentInvoker(methodName:String, includeInactive:Boolean = false, type:Class = null)
        {
            _methodName = methodName;
            _includeInactive = includeInactive;
            componentType = type;
        }
        
        //--------------------------------------------------------------------------
        //     
        //	PUBLIC METHODS 
        //     
        //--------------------------------------------------------------------------
        
        public function invoke(... args):void
        {
            if (_controller)
            {
                var engine:Entity = _controller._entity;
                if (engine && engine._enabled)
                {
                    Entity.broadcastMessage(engine, true, _methodName, _type, _includeInactive, args);
                }
            }
        }
        
        public function get componentType():Class
        {
            return _type;
        }
        
        public function set componentType(value:Class):void
        {
            if (value)
            {
                checkBehaviourSubclass(value);
                _type = value;
            }
            else
            {
                _type = Component;
            }
        }
        
        public function get includeInactive():Boolean
        {
            return _includeInactive;
        }
        
        public function set includeInactive(value:Boolean):void
        {
            _includeInactive = value;
        }
        
        //--------------------------------------------------------------------------
        //     
        //	PRIVATE METHODS 
        //     
        //--------------------------------------------------------------------------
        
        private function checkBehaviourSubclass(value:Class):void
        {
            if (value != Component && ClassType.isSubclassOf(value, Component) == false)
            {
                throw new ArgumentError(ClassType.getQualifiedClassName(this) + ", component must extend the " + ClassType.getQualifiedClassName(Component));
            }
        }
    }
}