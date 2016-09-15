package common.composite
{
    import common.events.Event;
    import common.system.ClassType;
    
    /**
     * ...
     * @author dorofiy.com
     */
    public class Entity extends Component
    {
        
        //--------------------------------------------------------------------------
        //     
        //	INTERNAL VARIABLES 
        //     
        //--------------------------------------------------------------------------
        
        internal var _behaviourController:ComponentController;
        internal var _components:ComponentCollection;
        
        //----------------------------------
        //	CONSTRUCTOR
        //----------------------------------
        
        public function Entity()
        {
            _components = new ComponentCollection(this);
        }
        
        //----------------------------------
        //	STATIC
        //----------------------------------
        
        private static var _broadcastListeners:Vector.<Component>;
        
        //--------------------------------------------------------------------------
        //     
        //	INTERNAL METHODS 
        //     
        //--------------------------------------------------------------------------
        
        internal static function broadcastMessage(target:Component, recursive:Boolean, methodName:String, type:Class = null, includeInactive:Boolean = false, ... args):void
        {
            if (target._enabled || includeInactive)
            {
                var context:ComponentContext = ComponentContext.getInstance();
                context.index = 0;
                context.args = args;
                context.recursive = recursive;
                context.includeInactive = includeInactive;
                if (type == null || ClassType.isSubclassOf(type, Component) == false)
                {
                    context.type = Component;
                }
                else
                {
                    context.type = type;
                }
                target.getComponentsByContext(context);
                
                var collection:Vector.<Component> = context.componentsCollection;
                var length:int = context.index;
                var current:Component;
                var method:Function;
                var methodLen:int;
                for (var i:int = 0; i < length; i++)
                {
                    current = collection[i];
                    method = (methodName in current) ? current[methodName] as Function : null;
                    if (Boolean(method))
                    {
                        methodLen = method.length;
                        if (methodLen == 0)
                        {
                            method();
                        }
                        else if (methodLen >= args.length)
                        {
                            method.apply(null, args);
                        }
                        else if (methodLen < args.length)
                        {
                            method.apply(null, args.slice(0, method.length));
                        }
                    }
                }
                ComponentContext.putInstance(context);
            }
        }
        
        //----------------------------------
        //	INSTANCE SECTION
        //----------------------------------
        
        //--------------------------------------------------------------------------
        //     
        //	PUBLIC METHODS 
        //     
        //--------------------------------------------------------------------------
        
        public function get components():IComponentCollection
        {
            return _components;
        }
        
        public override function get entity():Entity
        {
            return this;
        }
        
        public override function get parent():Entity
        {
            return _parent;
        }
        
        public function set parent(value:Entity):void
        {
            if (value == this)
            {
                throw new ArgumentError(ClassType.getQualifiedClassName(this) + ", An parent cannot be added as a child to itself or one of its children (or children's children, etc.)");
            }
            if (value != _parent)
            {
                if (_parent)
                {
                    _parent.removeComponent(this);
                }
                if (value != null)
                {
                    value.addComponent(this);
                }
            }
        }
        
        public function get behaviour():IBehaviourController
        {
            return _behaviourController ||= new ComponentController(this);
        }
        
        public override function addComponent(component:Object):Component
        {
            var target:Component;
            var targetEntity:Entity;
            if (component == null)
            {
                throw new ArgumentError(ClassType.getQualifiedClassName(this) + ", component can not be null");
            }
            if (component is Class)
            {
                target = Component.instantiate(Class(component)) as Component;
            }
            else
            {
                target = component as Component;
            }
            if (target == null)
            {
                throw new ArgumentError(ClassType.getQualifiedClassName(this) + ", component must extend the " + ClassType.getQualifiedClassName(Component));
            }
            
            targetEntity = target._entity;
            if (targetEntity)
            {
                targetEntity.removeComponent(target);
            }
            
            _components.add(target);
            return target;
        }
        
        public override function removeComponents(type:Class):Boolean
        {
            if (type == null)
            {
                throw new ArgumentError(ClassType.getQualifiedClassName(this) + ", type can not be null");
            }
            var result:Boolean = false;
            var components:Vector.<Component> = getComponents(type);
            for each (var item:Component in components)
            {
				item.dispose();
				result = true;
            }
            return result;
        }
        
        public override function removeComponent(component:Component):Boolean
        {
            if (component == null)
            {
                throw new ArgumentError(ClassType.getQualifiedClassName(this) + ", component can not be null");
            }
            var result:Boolean = _components.remove(component);
            return result;
        }
        
        public override function getComponent(type:Class):Component
        {
            if (type == null)
            {
                throw new ArgumentError(ClassType.getQualifiedClassName(this) + ", type can not be null");
            }
            return _components.getByType(type);
        }
        
        public override function getComponentByName(name:String):Component
        {
            if (name == null)
            {
                throw new ArgumentError(ClassType.getQualifiedClassName(this) + ", name can not be null");
            }
            return _components.getByName(name);
        }
        
        public override function getComponents(type:Class = null, includeInactive:Boolean = false, result:Vector.<Component> = null):Vector.<Component>
        {
            return _components.getComponents(type, includeInactive, result);
        }
        
        public override function getComponentsInChildren(type:Class = null, recursive:Boolean = true, includeInactive:Boolean = false, result:Vector.<Component> = null):Vector.<Component>
        {
            return _components.getComponentsInChildren(type, recursive, includeInactive, result);
        }
        
        public override function dispose():void
        {
            if (!disposed)
            {
                parent = null;
                if (_behaviourController)
                {
                    _behaviourController.dispose();
                }
                _components.dispose();
                super.dispose();
            }
        }
        
        public override function broadcastEvent(event:Event):void
        {
            if (event.bubbles)
                throw new ArgumentError("Broadcast of bubbling events is prohibited");
            
            var fromIndex:int = _broadcastListeners.length;
            getChildEventListeners(this, event.type, _broadcastListeners);
            var toIndex:int = _broadcastListeners.length;
            
            for (var i:int = fromIndex; i < toIndex; ++i)
                _broadcastListeners[i].dispatchEvent(event);
            
            _broadcastListeners.length = fromIndex;
        }
        
        public override function broadcastEventWith(type:String, data:Object = null):void
        {
            var event:Event = Event.fromPool(type, false, data);
            broadcastEvent(event);
            Event.toPool(event);
        }
        
        override public function broadcastEventAs(typeEvent:Class, type:String, data:Object = null, ...args):void 
        {
            var event:Event = Event.fromPoolAs(typeEvent, type, false, data, args);
            broadcastEvent(event);
            Event.toPoolAs(event);
        }
        
        //--------------------------------------------------------------------------
        //     
        //	INTERNAL METHODS 
        //     
        //--------------------------------------------------------------------------
        
        internal function getChildEventListeners(object:Component, eventType:Object, listeners:Vector.<Component>):void
        {
            var entity:Entity = object as Entity;
            if (object.hasEventListener(eventType))
            {
                listeners[listeners.length] = object;
            }
            
            if (entity)
            {
                var collection:Vector.<Component> = entity._components._collection;
                var num:int = collection.length;
                
                for (var i:int = 0; i < num; ++i)
                {
                    getChildEventListeners(collection[i], eventType, listeners);
                }
            }
        }
        
        internal override function getComponentsByContext(context:ComponentContext):void
        {
            if (_enabled || context.includeInactive)
            {
                _components.getComponentsByContext(context);
            }
        }
        
        internal override function attachToParent():void
        {
            super.attachToParent();
            attach();
        }
        
        internal override function detachFromParent():void
        {
            super.detachFromParent();
            detach();
        }
    }
}