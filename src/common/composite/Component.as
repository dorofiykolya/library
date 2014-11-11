package common.composite
{
    import common.events.Event;
    import common.events.EventDispatcher;
    import common.system.Assert;
    import common.system.Cache;
    import common.system.ClassType;
    import common.system.errors.IllegalArgumentError;
    import flash.errors.IllegalOperationError;
    import flash.utils.Dictionary;
    
    /**
     * ...
     * @author dorofiy.com
     */
    public class Component extends EventDispatcher
    {
        //--------------------------------------------------------------------------
        //     
        //	PRIVATE VARIABLES 
        //     
        //--------------------------------------------------------------------------
        
        private static const TYPE_NAME:String = ClassType.getQualifiedClassName(Component) + "-pool";
        private static const CACHE:Cache = Cache.cache;
        
        internal static function getPoolComponents(type:Class):Vector.<Component>
        {
            var cache:Dictionary = CACHE[TYPE_NAME] || (CACHE[TYPE_NAME] = new Dictionary());
            return cache[type] || (cache[type] = new <Component>[]);
        }
        
        //--------------------------------------------------------------------------
        //     
        //	INTERNAL VARIABLES 
        //     
        //--------------------------------------------------------------------------
        
        internal var _disposed:Boolean;
        internal var _reinitializeState:Boolean;
        
        internal var _entity:Entity;
        internal var _name:String;
        internal var _enabled:Boolean;
        internal var _parent:Entity;
        
        //----------------------------------
        //	CONSTRUCTOR
        //----------------------------------
        
        public function Component()
        {
            _name = "";
            _enabled = true;
        }
        
        public static function instantiate(componentType:Class):Component
        {
            var result:Component;
            var pool:Vector.<Component> = getPoolComponents(componentType);
            if (pool.length != 0)
            {
                result = pool.pop();
                result._reinitializeState = true;
                result._disposed = false;
                result.reinitialize();
                result._reinitializeState = false;
            }
            else
            {
                var tempResult:Object = new componentType;
                if (!(tempResult is Component))
                {
                    throw new IllegalArgumentError(ClassType.getQualifiedClassName(componentType) + ", component must extend the " + ClassType.getQualifiedClassName(Component));
                }
                result = Component(tempResult);
            }
            return result;
        }
        
        internal static function disposeComponent(item:Component):void
        {
            if (!item._disposed)
            {
                item._disposed = true;
                var pool:Vector.<Component> = getPoolComponents(ClassType.getClass(item));
                pool[pool.length] = item;
            }
        }
        
        //--------------------------------------------------------------------------
        //     
        //	PUBLIC SECTION 
        //     
        //--------------------------------------------------------------------------
        
        public function sendMessage(methodName:String, componentType:Class = null, includeInactive:Boolean = false, ... args):void
        {
            Entity.broadcastMessage.apply(null, args.splice(0, 0, this, false, methodName, componentType, includeInactive));
        }
        
        public function broadcastMessage(methodName:String, componentType:Class = null, includeInactive:Boolean = false, ... args):void
        {
            Entity.broadcastMessage.apply(null, args.splice(0, 0, this, true, methodName, componentType, includeInactive));
        }
        
        public function addComponent(component:Object):Component
        {
            if (_entity)
            {
                return _entity.addComponent(component);
            }
            return null;
        }
        
        public function removeComponents(type:Class):Boolean
        {
            if (_entity)
            {
                return _entity.removeComponents(type);
            }
            return false;
        }
        
        public function removeComponent(component:Component):Boolean
        {
            if (_entity)
            {
                return _entity.removeComponent(component);
            }
            return false;
        }
        
        public function broadcastEvent(event:Event):void
        {
            if (_entity)
            {
                _entity.broadcastEvent(event);
            }
        }
        
        public function broadcastEventWith(type:String, data:Object = null):void
        {
            if (_entity)
            {
                _entity.broadcastEventWith(type, data);
            }
        }
        
        public function broadcastEventAs(typeEvent:Class, type:String, data:Object = null, ... args):void
        {
            if (_entity)
            {
                _entity.broadcastEventAs(typeEvent, type, data, args);
            }
        }
        
        public function getComponent(type:Class):Component
        {
            if (_entity)
            {
                return _entity.getComponent(type);
            }
            return null;
        }
        
        public function getComponents(type:Class = null, includeInactive:Boolean = false, result:Vector.<Component> = null):Vector.<Component>
        {
            if (_entity)
            {
                return _entity.getComponents(type, includeInactive, result);
            }
            return null;
        }
        
        public function getComponentByName(name:String):Component
        {
            if (_entity)
            {
                return _entity.getComponentByName(name);
            }
            return null;
        }
        
        public function getComponentsInChildren(type:Class = null, recursive:Boolean = true, includeInactive:Boolean = false, result:Vector.<Component> = null):Vector.<Component>
        {
            return _entity.getComponentsInChildren(type, recursive, includeInactive, result);
        }
        
        public function get parent():Entity
        {
            return _entity;
        }
        
        public function get entity():Entity
        {
            return _entity;
        }
        
        public function get name():String
        {
            return _name;
        }
        
        public function set name(value:String):void
        {
            _name = value;
        }
        
        public function get enabled():Boolean
        {
            return _enabled;
        }
        
        public function set enabled(value:Boolean):void
        {
            _enabled = value;
        }
        
        public function get active():Boolean
        {
            if (_enabled)
            {
                if (_parent)
                {
                    return _parent.active;
                }
                return true;
            }
            return false;
        }
        
        public function get root():Component
        {
            var target:Component = this;
            while (target._parent)
            {
                target = target._parent;
            }
            return target;
        }
        
        public final function get disposed():Boolean
        {
            return _disposed;
        }
        
        public override function dispose():void
        {
            if (!_disposed)
            {
                if (_entity)
                {
                    _entity.removeComponent(this);
                }
                super.dispose();
                Component.disposeComponent(this);
            }
        }
        
        //--------------------------------------------------------------------------
        //     
        //	INTERNAL SECTION 
        //     
        //--------------------------------------------------------------------------
        
        internal function getComponentsByContext(context:ComponentContext):void
        {
            if (_entity)
            {
                _entity.getComponentsByContext(context);
            }
        }
        
        internal function setParent(value:Entity):void
        {
            var ancestor:Entity = value;
            while (ancestor != this && ancestor != null)
            {
                ancestor = ancestor._parent;
            }
            if (ancestor == this)
            {
                throw new ArgumentError(ClassType.getQualifiedClassName(this) + ", An object cannot be added as a child to itself or one of its children (or children's children, etc.)");
            }
            else
            {
                _parent = _entity = value;
            }
        }
        
        internal function attachToParent():void
        {
            dispatchEventWith(Event.ADDED, true);
            attach();
        }
        
        internal function detachFromParent():void
        {
            dispatchEventWith(Event.REMOVED, true);
            detach();
        }
        
        //--------------------------------------------------------------------------
        //     
        //	PROTECTED SECTION 
        //     
        //--------------------------------------------------------------------------
        
        protected function reinitialize():void
        {
            if (!_reinitializeState)
            {
                throw new IllegalOperationError("method is called internally by the framework");
            }
        }
        
        protected function attach():void
        {
        
        }
        
        protected function detach():void
        {
        
        }
    }
}