package common.events 
{
    
    /**
     * ...
     * @author dorofiy.com
     */
    public interface IDispatcher 
    {
        function dispatchEvent(event:Event):void;
        function dispatchEventWith(type:Object, bubbles:Boolean = false, data:Object = null):void;
        function dispatchEventAs(typeClass:Class, type:Object, bubbles:Boolean = false, data:Object = null, args:Array = null):void
        function hasEventListener(type:Object, listener:Function = null):Boolean;
    }
    
}