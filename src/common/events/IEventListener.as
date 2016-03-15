package common.events 
{
	
	/**
	 * ...
	 * @author dorofiy.com
	 */
	public interface IEventListener 
	{
		function addEventListener(type:Object, listener:Function):void;
        function removeEventListener(type:Object, listener:Function):void;
        function removeEventListeners(type:Object = null):void;
	}
	
}