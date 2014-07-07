package common.system.collection
{
	
	/**
	 * ...
	 * @author dorofiy.com
	 */
	public interface IDictionary extends ICollection, IEnumerable
	{
		function getItem(param1:Object):Object;
		function setItem(param1:Object, param2:Object):void;
		function get values():ICollection;
		function get keys():ICollection;
		function add(param1:Object, param2:Object):void;
		function contains(param1:Object):Boolean;
		function remove(param1:Object):void;
		function clear():void;
	}
}