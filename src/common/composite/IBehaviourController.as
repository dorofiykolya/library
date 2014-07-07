package common.composite 
{
	
	/**
	 * ...
	 * @author dorofiy.com
	 */
	public interface IBehaviourController 
	{
		function add(behaviour:ComponentBehaviour):ComponentBehaviour;
		function remove(behaviour:ComponentBehaviour):ComponentBehaviour;
	}
	
}