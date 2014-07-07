package common.system.reflection
{
	import common.system.Enum;
	
	/**
	 * ...
	 * @author dorofiy.com
	 */
	public class Access extends Enum
	{
		public static const READONLY:Access = new Access("readonly");
		public static const WRITEONLY:Access = new Access("writeonly");
		public static const READWRITE:Access = new Access("readwrite");
		
		public function Access(value:String)
		{
			super(value);
		}
		
		public static function getAccess(access:String):Access
		{
			return getEnum(Access, access) as Access;
		}
	}
}