package common.system.utils
{
	import flash.utils.ByteArray;
	
	/**
	 * ...
	 * @author dorofiy.com
	 */
	public class Base64
	{
		private static const ENCODE_CHARS:Vector.<int> = encodeChars();
		private static const DECODE_CHARS:Vector.<int> = decodeChars();
		private static var _tempBytes:ByteArray;
		
		public static function encodeString(data:String):String
		{
			var bytes:ByteArray = _tempBytes || (_tempBytes = new ByteArray());
			bytes.writeUTFBytes(data);
			var result:String = encode(bytes);
			bytes.clear();
			return result;
		}
		
		public static function encode(data:ByteArray):String
		{
			var result:ByteArray = new ByteArray();
			result.length = (2 + data.length - ((data.length + 2) % 3)) * 4 / 3;
			var index:int = 0;
			var mod:int = data.length % 3;
			var length:int = data.length - mod;
			var current:uint;
			var position:int = 0;
			while (index < length)
			{
				current = data[int(index++)] << 16 | data[int(index++)] << 8 | data[int(index++)];
				
				result[int(position++)] = ENCODE_CHARS[int(current >>> 18)];
				result[int(position++)] = ENCODE_CHARS[int(current >>> 12 & 0x3f)];
				result[int(position++)] = ENCODE_CHARS[int(current >>> 6 & 0x3f)];
				result[int(position++)] = ENCODE_CHARS[int(current & 0x3f)];
			}
			
			if (mod == 1)
			{				
				current = data[int(index)];
				
				result[int(position++)] = ENCODE_CHARS[int(current >>> 2)];
				result[int(position++)] = ENCODE_CHARS[int((current & 0x03) << 4)];
				result[int(position++)] = 61;
				result[int(position++)] = 61;
			}
			else if (mod == 2)
			{
				current = data[int(index++)] << 8 | data[int(index)];
				
				result[int(position++)] = ENCODE_CHARS[int(current >>> 10)];
				result[int(position++)] = ENCODE_CHARS[int(current >>> 4 & 0x3f)];
				result[int(position++)] = ENCODE_CHARS[int((current & 0x0f) << 2)];
				result[int(position++)] = 61;
			}
			
			return result.readUTFBytes(result.length);
		}
		
		public static function decode(str:String):ByteArray
		{
			var char1:int;
			var char2:int;
			var char3:int;
			var char4:int;
			var index:int = 0;
			var length:int = str.length;
			
			var result:ByteArray = new ByteArray();
			result.writeUTFBytes(str);
			var position:int = 0;
			while (index < length)
			{
				char1 = DECODE_CHARS[int(result[index++])];
				if (char1 == -1)
					break;
				
				char2 = DECODE_CHARS[int(result[index++])];
				if (char2 == -1)
					break;
				
				result[int(position++)] = (char1 << 2) | ((char2 & 0x30) >> 4);
				
				char3 = result[int(index++)];
				if (char3 == 61)
				{
					result.length = position;
					return result;
				}
				
				char3 = DECODE_CHARS[int(char3)];
				if (char3 == -1)
					break;
				
				result[int(position++)] = ((char2 & 0x0f) << 4) | ((char3 & 0x3c) >> 2);
				
				char4 = result[int(index++)];
				if (char4 == 61)
				{
					result.length = position;
					return result;
				}
				
				char4 = DECODE_CHARS[int(char4)];
				if (char4 == -1)
					break;
				
				result[int(position++)] = ((char3 & 0x03) << 6) | char4;
			}
			result.length = position;
			return result;
		}
		
		private static function encodeChars():Vector.<int>
		{
			var count:int = 64;
			var result:Vector.<int> = new Vector.<int>(count, true);
			var chars:String = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
			for (var i:int = 0; i < count; i++)
			{
				result[i] = chars.charCodeAt(i);
			}
			
			return result;
		}
		
		private static function decodeChars():Vector.<int>
		{
			var result:Vector.<int> = new <int>[
            -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
            -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
            -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, 62, -1, -1, -1, 63,
            52, 53, 54, 55, 56, 57, 58, 59, 60, 61, -1, -1, -1, -1, -1, -1,
            -1,  0,  1,  2,  3,  4,  5,  6,  7,  8,  9, 10, 11, 12, 13, 14,
            15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, -1, -1, -1, -1, -1,
            -1, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35, 36, 37, 38, 39, 40,
            41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, -1, -1, -1, -1, -1,
            -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
            -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
            -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
            -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
            -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
            -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
            -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1,
            -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1, -1];
			result.fixed = true;
			return result;
		}
	
	}

}