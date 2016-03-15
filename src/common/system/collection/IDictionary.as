package common.system.collection
{
	
	/**
	 * ...
	 * @author dorofiy.com
	 */
	public interface IDictionary extends ICollection, IEnumerable
	{
		function getItem(key:Object):Object;
		function setItem(key:Object, value:Object):void;
		function get values():ICollection;
		function get keys():ICollection;
		function add(key:Object, value:Object):void;
		function contains(key:Object):Boolean;
		function remove(key:Object):void;
		function clear():void;
	}
}