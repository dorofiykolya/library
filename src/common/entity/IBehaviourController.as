package common.entity 
{
	
	/**
	 * ...
	 * @author dorofiy.com
	 */
	public interface IBehaviourController 
	{
		function add(invoker:BehaviourInvoker):void;
		function remove(invoker:BehaviourInvoker):void;
	}
	
}