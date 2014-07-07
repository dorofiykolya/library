package common.system
{
	
	/**
	 * ...
	 * @author dorofiy.com
	 */
	public interface IDelegate
	{
		function add(listener:Function):void;
		function remove(listener:Function):void;
	}
}