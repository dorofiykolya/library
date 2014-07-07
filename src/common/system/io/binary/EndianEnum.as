package common.system.io.binary
{
	import common.system.Enum;
	import flash.utils.Endian;
	
	/**
	 * ...
	 * @author dorofiy.com
	 */
	public class EndianEnum extends Enum
	{
		
		public static const BIG:EndianEnum = new EndianEnum(Endian.BIG_ENDIAN);
		public static const LITTLE:EndianEnum = new EndianEnum(Endian.LITTLE_ENDIAN);
		
		public function EndianEnum(value:String)
		{
			super(value);
		}
		
		public static function getEndian(value:String):EndianEnum
		{
			return Enum.getEnum(EndianEnum, value) as EndianEnum;
		}
	}
}