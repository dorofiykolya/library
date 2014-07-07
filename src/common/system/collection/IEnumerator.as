package common.system.collection
{
	
	/**
	 * ...
	 * @author dorofiy.com
	 */
	public interface IEnumerator
	{
		function get current():Object;
		function moveNext():Boolean;
		function reset():void;
	}

}