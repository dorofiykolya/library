package common.system.io.serialization.binary.json
{
	import common.system.IDisposable;
	import common.system.io.serialization.binary.BinaryReader;
	import flash.utils.ByteArray;
	
	/**
	 * ...
	 * @author dorofiy.com
	 */
	public class BinaryJSONReader extends BinaryReader implements IDisposable
	{
		
		public function BinaryJSONReader()
		{
		
		}
		
		public override function read(value:ByteArray):Object
		{
			return readBuffer(value);
		}
		
		protected function readBuffer(buffer:ByteArray):Object
		{
			var byte:int = buffer.readUnsignedByte();
			switch (byte)
			{
				case BinaryJSONValue.BYTE: 
					return readByte(buffer);
				case BinaryJSONValue.UBYTE: 
					return readUByte(buffer);
				case BinaryJSONValue.SHORT: 
					return readShort(buffer);
				case BinaryJSONValue.USHORT: 
					return readUShort(buffer);
				case BinaryJSONValue.INT: 
					return readInt(buffer);
				case BinaryJSONValue.UINT: 
					return readUInt(buffer);
				case BinaryJSONValue.DOUBLE: 
					return readDouble(buffer);
				case BinaryJSONValue.STRING: 
					return readString(buffer);
				case BinaryJSONValue.BOOLEAN: 
					return readBoolean(buffer);
				case BinaryJSONValue.OBJECT: 
					return readObject(buffer);
				case BinaryJSONValue.ARRAY: 
					return readArray(buffer);
				case BinaryJSONValue.NULL: 
					return null;
			}
			throw new ArgumentError();
		}
		
		protected function readArray(byteArray:ByteArray):Object
		{
			var len:int = byteArray.readInt();
			if (len < 0)
			{
				return null;
			}
			var current:Object = new Array(len);
			for (var i:int = 0; i < len; i++)
			{
				current[i] = readBuffer(byteArray);
			}
			return current;
		}
		
		protected function readObject(byteArray:ByteArray):Object
		{
			var fields:int = byteArray.readInt();
			if (fields < 0)
			{
				return null;
			}
			var current:Object = {};
			var fieldName:String;
			for (var i:int = 0; i < fields; i++)
			{
				fieldName = readField(byteArray);
				current[fieldName] = readBuffer(byteArray);
			}
			return current;
		}
		
		protected function readField(byteArray:ByteArray):String
		{
			return readString(byteArray);
		}
		
		protected function readByte(byteArray:ByteArray):int
		{
			return byteArray.readByte();
		}
		
		protected function readUByte(byteArray:ByteArray):int
		{
			return byteArray.readUnsignedByte();
		}
		
		protected function readShort(byteArray:ByteArray):int
		{
			return byteArray.readShort();
		}
		
		protected function readUShort(byteArray:ByteArray):int
		{
			return byteArray.readUnsignedShort();
		}
		
		protected function readInt(byteArray:ByteArray):int
		{
			return byteArray.readInt();
		}
		
		protected function readUInt(byteArray:ByteArray):uint
		{
			return byteArray.readUnsignedInt();
		}
		
		protected function readDouble(byteArray:ByteArray):Number
		{
			return byteArray.readDouble();
		}
		
		protected function readBoolean(byteArray:ByteArray):Boolean
		{
			return byteArray.readBoolean();
		}
		
		protected function readString(byteArray:ByteArray):String
		{
			var index:int = byteArray.position;
			while (byteArray[index] != 0)
			{
				index++;
			}
			var result:String = byteArray.readUTFBytes(int(index - byteArray.position));
			byteArray.readByte();
			return result;
		}
		
		/* INTERFACE common.system.IDisposable */
		
		public function dispose():void
		{
		
		}
	
	}

}