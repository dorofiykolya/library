package common.entity
{
	import common.system.IDisposable;
	import common.system.TypeObject;
	
	/**
	 * ...
	 * @author dorofiy.com
	 */
	public class BehaviourController extends TypeObject implements IBehaviourController, IDisposable
	{
		//--------------------------------------------------------------------------
		//     
		//	INTERNAL VARIABLES 
		//     
		//--------------------------------------------------------------------------
		
		internal var _entity:Entity;
		
		//--------------------------------------------------------------------------
		//     
		//	PRIVATE VARIABLES 
		//     
		//--------------------------------------------------------------------------
		
		private var _collection:BehaviourControllerCollection;
		
		//----------------------------------
		//	CONSTRUCTOR
		//----------------------------------
		
		public function BehaviourController(behaviourEngine:Entity)
		{
			_entity = behaviourEngine;
			_collection = new BehaviourControllerCollection();
		}
		
		//--------------------------------------------------------------------------
		//     
		//	PUBLIC METHODS 
		//     
		//--------------------------------------------------------------------------
		
		/* INTERFACE common.entity.IBehaviourController */
		
		public function add(invoker:BehaviourInvoker):void
		{
			var invokerController:BehaviourController = invoker._controller;
			if (invokerController != this)
			{
				if (invokerController)
				{
					invokerController.remove(invoker);
				}
				_collection.add(invoker);
				invoker._controller = this;
				invoker.attachInvoker();
			}
		}
		
		public function remove(invoker:BehaviourInvoker):void
		{
			_collection.remove(invoker);
			invoker._controller = null;
			invoker.detachInvoker();
		}
		
		/* INTERFACE common.system.IDisposable */
		
		public function dispose():void
		{
			_collection.dispose();
		}
	}
}