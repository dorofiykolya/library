package common.entity 
{
	import common.system.collection.IEnumerable;
	import common.system.collection.IEnumerator;
	
	/**
	 * ...
	 * @author dorofiy.com
	 */
	public interface IChildList extends IEnumerable
	{
		//--------------------------------------------------------------------------
		//     
		//	PUBLIC PROPERTIES 
		//     
		//--------------------------------------------------------------------------
		
		function get numChildren():int;
		
		//--------------------------------------------------------------------------
		//     
		//	PUBLIC METHODS 
		//     
		//--------------------------------------------------------------------------
		
		function add(child:Entity):Entity;
		function addAt(child:Entity, index:int):Entity;
		function addRange(collection:Vector.<Entity>):void;
		function contains(child:Entity, includingChildren:Boolean = false):Boolean;
		function getAt(index:int):Entity;
		function getByName(name:String):Entity;
		function getByType(type:Class):Entity;
		function getChildren():Vector.<Entity>;
		function getIndex(child:Entity):int;
		function getRange(index:int, count:int):Vector.<Entity>;
		function remove(child:Entity):Boolean;
		function removeAll():void;
		function removeAt(index:int):Entity;
		function removeRange(index:int, count:int):Vector.<Entity>;
		function reverse():void;
		function setIndex(child:Entity, index:int):void;
		function sort(sortFunction:Function):void;
		function swap(child1:Entity, child2:Entity):void;
		function swapIndex(index1:int, index2:int):void;
		
	}
	
}