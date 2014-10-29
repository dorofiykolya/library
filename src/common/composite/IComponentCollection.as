package common.composite
{
    
    /**
     * ...
     * @author dorofiy.com
     */
    public interface IComponentCollection
    {
        //--------------------------------------------------------------------------
        //     
        //	PUBLIC PROPERTIES 
        //     
        //--------------------------------------------------------------------------
        
        function get count():int;
        function get components():Vector.<Component>;
        
        //--------------------------------------------------------------------------
        //     
        //	PUBLIC METHODS 
        //     
        //--------------------------------------------------------------------------
        
        function add(component:Component):Component;
        function addAt(component:Component, index:int):Component;
        function addRange(collection:Vector.<Component>):void;
        function contains(component:Component, includingChildren:Boolean = false):Boolean;
        function getAt(index:int):Component;
        function getByName(name:String):Component;
        function getByType(type:Class):Component;
        function getCollection():Vector.<Component>;
        function getIndex(component:Component):int;
        function getRange(index:int, count:int):Vector.<Component>;
        function remove(component:Component):Boolean;
        function removeAll():void;
        function removeAt(index:int):Component;
        function removeRange(beginIndex:int = 0, endIndex:int = -1):Vector.<Component>;
        function reverse():void;
        function setIndex(component:Component, index:int):void;
        function sort(sortFunction:Function):void;
        function swap(component1:Component, component2:Component):void;
        function swapIndex(index1:int, index2:int):void;
    }

}