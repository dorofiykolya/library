package common.composite 
{
	import common.system.IDisposable;
	import common.system.ITypeObject;
	import common.system.TypeObject;
	/**
	 * ...
	 * @author dorofiy.com
	 */
	public class ComponentBehaviour extends EventDispatcher
	{
		//--------------------------------------------------------------------------
		//     
		//	INTERNAL VARIABLES 
		//     
		//--------------------------------------------------------------------------
		
		internal var _controller:ComponentController;
		
		//----------------------------------
		//	CONSTRUCTOR
		//----------------------------------
		
		public function ComponentBehaviour() 
		{
			
		}
		
		//--------------------------------------------------------------------------
		//     
		//	PUBLIC METHODS 
		//     
		//--------------------------------------------------------------------------
		
		public function get entity():Entity
		{
			return _controller ? _controller._entity : null;
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
	}
}