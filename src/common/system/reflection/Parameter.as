package common.system.reflection
{
	import common.system.ClassType;
	import common.system.TypeObject;
	
	/**
	 * ...
	 * @author dorofiy.com
	 */
	public class Parameter extends TypeObject
	{
		internal var _index:int;
		internal var _typeName:String;
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
			if (_type != null)
			{
				return _type;
			}
			if (_typeName != null)
			{
				_type = Class(ClassType.getDefinitionByName(_typeName));
			}
			return _type;
		}
		
		public function get optional():Boolean 
		{
			return _optional;
		}
	
	}

}