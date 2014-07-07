package common.system.io.serialization.binary.json 
{
	import common.system.TypeObject;
	
	/**
	 * ...
	 * @author dorofiy.com
	 */
	public class BinaryJSONValue extends TypeObject
	{
		public static const BOOLEAN:int = 1;
		public static const BYTE:int = 2;
		public static const UBYTE:int = 3;
		public static const SHORT:int = 4;
		public static const USHORT:int = 5;
		public static const INT:int = 6;
		public static const UINT:int = 7;
		public static const DOUBLE:int = 8;
		public static const STRING:int = 9;
		public static const OBJECT:int = 10;
		public static const ARRAY:int = 11;
		public static const NULL:int = 12;
		
		public function BinaryJSONValue()
		{
		
		}
	}
}