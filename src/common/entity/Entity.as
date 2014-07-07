package common.entity
{
	import common.system.ClassType;
	import common.system.IDisposable;
	import common.system.TypeObject;
	
	/**
	 * ...
	 * @author dorofiy.com
	 */
	public class Entity extends TypeObject implements IDisposable
	{
		//--------------------------------------------------------------------------
		//     
		//	INTERNAL VARIABLES 
		//     
		//--------------------------------------------------------------------------
		
		internal var _behaviourController:BehaviourController;
		internal var _components:ComponentCollection;
		internal var _children:EntityCollection;
		internal var _parent:Entity;
		
		internal var _name:String;
		internal var _enabled:Boolean;
		
		//----------------------------------
		//	CONSTRUCTOR
		//----------------------------------
		
		public function Entity()
		{
			_name = "";
			_enabled = true;
			_components = new ComponentCollection();
			_children = new EntityCollection(this);
		}
		
		//----------------------------------
		//	STATIC SECTION
		//----------------------------------
		
		//--------------------------------------------------------------------------
		//     
		//	PUBLIC METHODS 
		//     
		//--------------------------------------------------------------------------
		
		public static function broadcastMessage(entity:Entity, recursive:Boolean, methodName:String, flags:uint = 15, componentType:Class = null, ... args):void
		{
			var context:BehaviourContext = BehaviourContext.getInstance();
			context.index = 0;
			context.args = args;
			context.recursive = recursive;
			context.flags = flags;
			if (context.isComponentType)
			{
				if (componentType == null || ClassType.isSubclassOf(componentType, Behaviour) == false)
				{
					context.type = Behaviour;
				}
				else
				{
					context.type = componentType;
				}
			}
			entity.getBehaviours(context);
			
			var collection:Vector.<Behaviour> = context.behavioursCollection;
			var length:int = context.index;
			var isMethod:Boolean = context.isMethod;
			var current:Behaviour;
			var method:Function;
			for (var i:int = 0; i < length; i++) 
			{
				current = collection[i];
				if (isMethod)
				{
					method = (methodName in current)? current[methodName] as Function : null;
					if (Boolean(method))
					{
						if (method.length >= args.length)
						{
							method.apply(null, args);
						}
						else if (method.length < args.length)
						{
							method.apply(null, args.slice(0, method.length));
						}
					}
				}
			}
			
			BehaviourContext.putInstance(context);
		}
		
		//----------------------------------
		//	INSTANCE SECTION
		//----------------------------------
		
		//--------------------------------------------------------------------------
		//     
		//	PUBLIC METHODS 
		//     
		//--------------------------------------------------------------------------
		
		public function get entity():Entity
		{
			return this;
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
		
		public function get children():IChildList
		{
			return _children;
		}
		
		public function get parent():Entity
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
					_parent._children.remove(this);
				}
				if (value != null)
				{
					value._children.add(this);
				}
			}
		}
		
		public function get behaviour():IBehaviourController
		{
			return _behaviourController ||= new BehaviourController(this);
		}
		
		public function get root():Entity
		{
			var target:Entity = this;
			while (target._parent)
			{
				target = target._parent;
			}
			return target;
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
		
		public function addComponent(component:Object):Component
		{
			var target:Component;
			var targetEntity:Entity;
			if (component == null)
			{
				throw new ArgumentError(ClassType.getQualifiedClassName(this) + ", component can not be null");
			}
			if (component is Class)
			{
				target = new component as Component;
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
			target.attachComponent(this);
			return target;
		}
		
		public function removeComponents(type:Class):Boolean
		{
			if (type == null)
			{
				throw new ArgumentError(ClassType.getQualifiedClassName(this) + ", type can not be null");
			}
			var result:Boolean = false;
			var components:Vector.<Component> = getComponents(type);
			for each (var item:Component in components)
			{
				if (_components.remove(item))
				{
					item.detachComponent();
					result = true;
				}
			}
			return result;
		}
		
		public function removeComponent(component:Component):Boolean
		{
			if (component == null)
			{
				throw new ArgumentError(ClassType.getQualifiedClassName(this) + ", component can not be null");
			}
			var result:Boolean = _components.remove(component);
			if (result)
			{
				component.detachComponent();
			}
			return result;
		}
		
		public function getAllComponents(type:Class = null):Vector.<Component>
		{
			var result:Vector.<Component> = new Vector.<Component>();
			var components:Vector.<Component> = getComponents(type);
			var current:Component;
			var index:int;
			result.length += components.length;
			for each (current in components) 
			{
				result[index] = current;
				index++;
			}
			components = getComponentsInChildren(type, true, true);
			for each (current in components) 
			{
				result[index] = current;
				index++;
			}
			result.length = index;
			return result;
		}
		
		public function getComponent(type:Class):Component
		{
			if (type == null)
			{
				throw new ArgumentError(ClassType.getQualifiedClassName(this) + ", type can not be null");
			}
			return _components.getByType(type);
		}
		
		public function getComponentByName(name:String):Component
		{
			if (name == null)
			{
				throw new ArgumentError(ClassType.getQualifiedClassName(this) + ", name can not be null");
			}
			return _components.getByName(name);
		}
		
		public function getComponents(type:Class = null):Vector.<Component>
		{
			return _components.getCollection(type);
		}
		
		public function getComponentsInChildren(type:Class = null, recursive:Boolean = true, includeInactive:Boolean = false):Vector.<Component>
		{
			if (recursive)
			{
				return _children.getComponentsInChildren(type, includeInactive);
			}
			return _children.getComponents(type, includeInactive);
		}
		
		public function sendMessage(methodName:String, flags:uint = 15, componentType:Class = null, ... params):void
		{
			Entity.broadcastMessage.apply(null, params.splice(0, 0, this, false, methodName, flags, componentType));
		}
		
		public function broadcastMessage(methodName:String, flags:uint = 15, componentType:Class = null, ... params):void
		{
			Entity.broadcastMessage.apply(null, params.splice(0, 0, this, true, methodName, flags, componentType));
		}
		
		public function dispose():void
		{
			parent = null;
			_behaviourController.dispose();
			_children.dispose();
			_components.dispose();
		}
		
		//--------------------------------------------------------------------------
		//     
		//	INTERNAL METHODS 
		//     
		//--------------------------------------------------------------------------
		
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
				_parent = value;
			}
		}
		
		internal function getBehaviours(behaviour:BehaviourContext):void
		{
			if (_enabled && behaviour.isEnabled || !_enabled && behaviour.isDisabled)
			{
				_components.getBehaviours(behaviour);
				
				if (behaviour.recursive)
				{
					for each (var entity:Entity in _children)
					{
						entity.getBehaviours(behaviour);
					}
				}
			}
		}
		
		internal function attachToParent():void
		{
			attach();
		}
		
		internal function detachFromParent():void
		{
			detach();
		}
		
		//--------------------------------------------------------------------------
		//     
		//	PROTECTED METHODS 
		//     
		//--------------------------------------------------------------------------
		
		protected function attach():void
		{
			
		}
		
		protected function detach():void
		{
			
		}
	}
}