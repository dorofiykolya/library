package common.entity
{
	import common.system.ClassType;
	import common.system.IDisposable;
	import common.system.TypeObject;
	
	/**
	 * ...
	 * @author dorofiy.com
	 */
	public class BehaviourInvoker extends TypeObject implements IDisposable
	{
		//--------------------------------------------------------------------------
		//     
		//	INTERNAL VARIABLES 
		//     
		//--------------------------------------------------------------------------
		
		internal var _controller:BehaviourController;
		
		//--------------------------------------------------------------------------
		//     
		//	PRIVATE VARIABLES 
		//     
		//--------------------------------------------------------------------------
		
		private var _methodName:String;
		private var _flags:uint;
		private var _type:Class;
		private var _behaviour:BehaviourContext;
		
		//----------------------------------
		//	CONSTRUCTOR
		//----------------------------------
		
		public function BehaviourInvoker(methodName:String, flags:uint = 15, type:Class = null)
		{
			_methodName = methodName;
			_flags = flags;
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
					Entity.broadcastMessage(engine, true, _methodName, _flags, _behaviour.type, args);
				}
			}
		}
		
		public function get entity():Entity
		{
			return _controller ? _controller._entity : null;
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
				_type = Behaviour;
			}
		}
		
		/* INTERFACE common.system.IDisposable */
		
		public function dispose():void
		{
			_behaviour.dispose();
		}
		
		//--------------------------------------------------------------------------
		//     
		//	INTERNAL METHODS 
		//     
		//--------------------------------------------------------------------------
		
		internal function attachInvoker():void
		{
			attach();
		}
		
		internal function detachInvoker():void
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
		
		//--------------------------------------------------------------------------
		//     
		//	PRIVATE METHODS 
		//     
		//--------------------------------------------------------------------------
		
		private function checkBehaviourSubclass(value:Class):void
		{
			if (value != Behaviour && ClassType.isSubclassOf(value, Behaviour) == false)
			{
				throw new ArgumentError(ClassType.getQualifiedClassName(this) + ", component must extend the " + ClassType.getQualifiedClassName(Behaviour));
			}
		}
	}
}