package common.system.text
{
	import common.system.Enum;
	
	/**
	 * ...
	 * @author dorofiy.com
	 */
	public class SplitFlags
	{
		public static const NONE:int = 0;
		public static const REMOVE_EMPTY:int = 1 << 1;
		public static const REMOVE_WHITESPACE:int = 1 << 2;
		public static const TRIM:int = 1 << 3;
	}
}