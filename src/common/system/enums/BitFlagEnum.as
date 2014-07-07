package common.system.enums
{
	import common.system.ClassType;
	import common.system.Enum;
	import common.system.utils.BitFlagUtil;
	import flash.utils.Dictionary;
	
	/**
	 * ...
	 * @author ...
	 */
	public class BitFlagEnum extends Enum
	{
		private static const DICTIONARY:Dictionary = new Dictionary();
		
		public function BitFlagEnum()
		{
			super(getMask());
		}
		
		private function getMask():uint
		{
			var type:Class = getType().type;
			var collection:int = DICTIONARY[type];
			collection++;
			if (collection > 31)
			{
				throw new RangeError("the maximum number of bits");
			}
			DICTIONARY[type] = collection;
			return uint(1 << collection);
		}
		
		public static function setFlag(value:Boolean, flags:uint, ... maskFlags):uint
		{
			var mask:uint = combine.apply(null, maskFlags);
			return BitFlagUtil.setFlag(flags, mask, true);
		}
		
		public static function getFlag(flags:uint, ... maskFlags):Boolean
		{
			var mask:uint = combine.apply(null, maskFlags);
			return BitFlagUtil.getFlag(flags, mask);
		}
		
		public static function combine(... maskFlags):uint
		{
			var mask:uint;
			for each (var item:Object in maskFlags)
			{
				if (item == null)
				{
					throw new ArgumentError(ClassType.getQualifiedClassName(item) + ", argument can not be null");
				}
				if ((item is BitFlagEnum) == false)
				{
					throw new ArgumentError(ClassType.getType(item).qualifiedClassName + " class must extend: " + ClassType.getType(BitFlagEnum).qualifiedClassName);
				}
				mask = BitFlagUtil.setFlag(mask, uint(BitFlagEnum(item).value), true);
			}
			return mask;
		}
	}
}