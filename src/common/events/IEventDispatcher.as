package common.events 
{
    
    /**
     * ...
     * @author dorofiy.com
     */
    public interface IEventDispatcher extends IDispatcher
    {
        function addEventListener(type:Object, listener:Function):void;
        function removeEventListener(type:Object, listener:Function):void;
        function removeEventListeners(type:Object = null):void;
    }
    
}