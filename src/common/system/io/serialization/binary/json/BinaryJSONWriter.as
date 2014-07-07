package common.system.io.serialization.binary.json
{
	import common.system.ClassType;
	import common.system.IDisposable;
	import common.system.io.binary.Byte;
	import common.system.io.binary.Short;
	import common.system.io.binary.UByte;
	import common.system.io.binary.UShort;
	import common.system.io.serialization.binary.BinaryWriter;
	import common.system.Type;
	import common.system.utils.ObjectUtils;
	import flash.utils.ByteArray;
	
	/**
	 * ...
	 * @author dorofiy.com
	 */
	public class BinaryJSONWriter extends BinaryWriter implements IDisposable
	{
		
		public function BinaryJSONWriter()
		{
		
		}
		
		public override function write(value:Object):ByteArray
		{
			var buffer:ByteArray = new ByteArray();
			writeBuffer(value, buffer);
			return buffer;
		}
		
		protected function writeBuffer(value:Object, buffer:ByteArray):void
		{
			var type:Class = ClassType.getClass(value);
			switch (type)
			{
				case int: 
					writeAsInt(int(value), buffer);
					break;
				case uint: 
					writeAsUInt(uint(value), buffer);
					break;
				case Number: 
					writeNumber(Number(value), buffer);
					break;
				case Boolean: 
					writeBoolean(value, buffer);
					break;
				case String: 
					writeString(value, buffer);
					break;
				case Object: 
					writeObject(value, buffer);
					break;
				case Array: 
					writeArray(value, buffer);
					break;
				case null: 
					writeNull(value, buffer);
					break;
				default: 
					writeType(value, buffer);
					break;
			}
		}
		
		protected function writeNull(value:Object, buffer:ByteArray):void
		{
			buffer.writeByte(BinaryJSONValue.NULL);
		}
		
		protected function writeType(value:Object, buffer:ByteArray):void
		{
			var type:Type = ClassType.getType(value);
			if (type.isArray || type.isVector)
			{
				writeArray(value, buffer);
			}
			writeBuffer(ObjectUtils.toObject(value), buffer);
		}
		
		protected function writeArray(value:Object, buffer:ByteArray):void
		{
			buffer.writeByte(BinaryJSONValue.ARRAY);
			var len:int = value.length;
			var current:Object;
			buffer.writeInt(len);
			for (var i:int = 0; i < len; i++)
			{
				current = value[i];
				writeBuffer(current, buffer);
			}
		}
		
		protected function writeObject(value:Object, buffer:ByteArray):void
		{
			buffer.writeByte(BinaryJSONValue.OBJECT);
			var members:Vector.<String> = ObjectUtils.getNamesOfMembers(value, ObjectUtils.DYNAMIC_FLAG);
			var len:int = members.length;
			var current:String;
			buffer.writeInt(len);
			for (var i:int = 0; i < len; i++)
			{
				current = members[i];
				writeField(current, buffer);
				writeBuffer(value[current], buffer);
			}
		}
		
		protected function writeField(value:String, buffer:ByteArray):void
		{
			buffer.writeUTFBytes(value);
			buffer.writeByte(0);
		}
		
		protected function writeString(value:Object, buffer:ByteArray):void
		{
			buffer.writeByte(BinaryJSONValue.STRING);
			buffer.writeUTFBytes(String(value));
			buffer.writeByte(0);
		}
		
		protected function writeBoolean(value:Object, buffer:ByteArray):void
		{
			buffer.writeByte(BinaryJSONValue.BOOLEAN);
			buffer.writeBoolean(Boolean(value));
		}
		
		protected function writeNumber(value:Number, buffer:ByteArray):void
		{
			buffer.writeByte(BinaryJSONValue.DOUBLE);
			buffer.writeDouble(Number(value));
		}
		
		protected function writeAsUInt(value:uint, buffer:ByteArray):void
		{
			if (value >= UByte.MIN_VALUE && value <= UByte.MAX_VALUE)
			{
				writeUByte(value, buffer);
			}
			else if (value >= UShort.MIN_VALUE && value <= UShort.MAX_VALUE)
			{
				writeUShort(value, buffer);
			}
			else
			{
				writeUInt(value, buffer);
			}
		}
		
		protected function writeAsInt(value:int, buffer:ByteArray):void
		{
			if (value >= Byte.MIN_VALUE && value <= Byte.MAX_VALUE)
			{
				writeByte(value, buffer);
			}
			else if (value >= UByte.MIN_VALUE && value <= UByte.MAX_VALUE)
			{
				writeUByte(value, buffer);
			}
			else if (value >= Short.MIN_VALUE && value <= Short.MAX_VALUE)
			{
				writeShort(value, buffer);
			}
			else if (value >= UShort.MIN_VALUE && value < UShort.MAX_VALUE)
			{
				writeUShort(value, buffer);
			}
			else
			{
				writeInt(value, buffer);
			}
		}
		
		protected function writeShort(value:int, buffer:ByteArray):void
		{
			buffer.writeByte(BinaryJSONValue.SHORT);
			buffer.writeShort(value);
		}
		
		protected function writeUShort(value:int, buffer:ByteArray):void
		{
			buffer.writeByte(BinaryJSONValue.USHORT);
			buffer.writeShort(value);
		}
		
		protected function writeInt(value:int, buffer:ByteArray):void
		{
			buffer.writeByte(BinaryJSONValue.INT);
			buffer.writeInt(value);
		}
		
		protected function writeUInt(value:uint, buffer:ByteArray):void
		{
			buffer.writeByte(BinaryJSONValue.UINT);
			buffer.writeUnsignedInt(value);
		}
		
		protected function writeByte(value:int, buffer:ByteArray):void
		{
			buffer.writeByte(BinaryJSONValue.BYTE);
			buffer.writeByte(value);
		}
		
		protected function writeUByte(value:int, buffer:ByteArray):void
		{
			buffer.writeByte(BinaryJSONValue.UBYTE);
			buffer.writeByte(value);
		}
		
		/* INTERFACE common.system.IDisposable */
		
		public function dispose():void
		{
		
		}
	}
}