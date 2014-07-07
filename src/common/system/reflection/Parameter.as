package common.system.reflection
{
	import common.system.TypeObject;
	
	/**
	 * ...
	 * @author dorofiy.com
	 */
	public class Parameter extends TypeObject
	{
		internal var _index:int;
		internal var _type:Class;
		internal var _optional:Boolean;
		
		public function Parameter()
		{
		
		}
		
		public function get index():int 
		{
			return _index;
		}
		
		public function get type():Class 
		{
			return _type;
		}
		
		public function get optional():Boolean 
		{
			return _optional;
		}
	
	}

}