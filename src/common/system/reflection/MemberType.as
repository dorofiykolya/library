package common.system.reflection
{
	import common.system.Enum;
	
	/**
	 * ...
	 * @author dorofiy.com
	 */
	public class MemberType extends Enum
	{
		public static const FIELD:MemberType = new MemberType("field");
		public static const PROPERTY:MemberType = new MemberType("property");
		public static const METHOD:MemberType = new MemberType("method");
		public static const CONSTRUCTOR:MemberType = new MemberType("constructor");
		public static const CONSTANT:MemberType = new MemberType("constant");
		public static const DYNAMIC:MemberType = new MemberType("dynamic");
		
		public function MemberType(value:String)
		{
			super(value);
		}
		
		public static function getMemberType(value:String):MemberType
		{
			return getEnum(MemberType, value) as MemberType;
		}
	}
}