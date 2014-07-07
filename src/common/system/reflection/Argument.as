package common.system.reflection
{
	import common.system.TypeObject;
	
	/**
	 * ...
	 * @author dorofiy.com
	 */
	public class Argument extends TypeObject
	{
		internal var _name:String;
		internal var _value:*;
		
		public function Argument(name:String = null, value:* = null)
		{
			this._name = name;
			this._value = value;
		}
		
		public function get name():String 
		{
			return _name;
		}
		
		public function get value():* 
		{
			return _value;
		}
	
	}

}