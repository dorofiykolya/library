package common.system.collection 
{
	
	/**
	 * ...
	 * @author dorofiy.com
	 */
	public interface IList extends ICollection, IEnumerable
	{
		function getItem(index:int):Object;
		function setItem(index:int, value:Object):void;
		function add(value:Object):void;
		function remove(value:Object):void;
		function removeAt(index:int):void;
		function insert(index:int, value:Object):void;
		function contains(value:Object):Boolean;
		function indexOf(value:Object):int;
		function clear():void;
	}
	
}