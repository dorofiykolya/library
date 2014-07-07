package common.entity
{
	import common.system.ClassType;
	import common.system.IDisposable;
	import common.system.TypeObject;
	
	/**
	 * ...
	 * @author dorofiy.com
	 */
	public class Component extends TypeObject implements IDisposable
	{
		//--------------------------------------------------------------------------
		//     
		//	INTERNAL VARIABLES 
		//     
		//--------------------------------------------------------------------------
		
		internal var _entity:Entity;
		internal var _name:String;
		internal var _enabled:Boolean;
		
		//----------------------------------
		//	CONSTRUCTOR
		//----------------------------------
		
		public function Component()
		{
			_name = "";
			_enabled = true;
		}
		
		//--------------------------------------------------------------------------
		//     
		//	PUBLIC SECTION 
		//     
		//--------------------------------------------------------------------------
		
		public function getComponent(type:Class):Component
		{
			if (_entity)
			{
				return _entity.getComponent(type);
			}
			return null;
		}
		
		public function getComponents(type:Class = null):Vector.<Component>
		{
			if (_entity)
			{
				return _entity.getComponents(type);
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
		
		public function sendMessage(methodName:String, flags:uint = 15, componentType:Class = null, ... params):void
		{
			if (_entity)
			{
				Entity.broadcastMessage.apply(null, params.splice(0, 0, _entity, false, methodName, flags, componentType));
			}
		}
		
		public function broadcastMessage(methodName:String, flags:uint = 15, componentType:Class = null, ... params):void
		{
			if (_entity)
			{
				Entity.broadcastMessage.apply(null, params.splice(0, 0, _entity, true, methodName, flags, componentType));
			}
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
		
		public function dispose():void
		{
			if (_entity)
			{
				_entity.removeComponent(this);
			}
		}
		
		//--------------------------------------------------------------------------
		//     
		//	INTERNAL SECTION 
		//     
		//--------------------------------------------------------------------------
		
		internal function attachComponent(entity:Entity):void
		{
			_entity = entity;
			attach();
		}
		
		internal function detachComponent():void
		{
			detach();
			_entity = null;
		}
		
		//--------------------------------------------------------------------------
		//     
		//	PROTECTED SECTION 
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