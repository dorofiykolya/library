package common.system.enums
{
	import common.system.ClassType;
	import common.system.Enum;
	
	/**
	 * ...
	 * @author dorofiy.com
	 */
	public class NameEnum extends Enum
	{
		private var _name:String;
		
		public function NameEnum(name:String, value:Object)
		{
			super(value);
            _name = name;
			if (Object(this).constructor === NameEnum)
			{
				throw new ArgumentError('ArgumentError: ' + ClassType.getQualifiedClassName(this) + ' class cannot be instantiated.');
			}
		}
		
		public function get name():String
		{
			return _name;
		}
		
		override public function toString():String
		{
			return "[name:" + _name + " (" + super.toString() + ")]";
		}
	}
}