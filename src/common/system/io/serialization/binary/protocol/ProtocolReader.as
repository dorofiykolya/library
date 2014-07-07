package common.system.io.serialization.binary.protocol
{
	import common.system.IDisposable;
	import common.system.io.binary.Byte;
	import common.system.io.binary.EndianEnum;
	import common.system.io.binary.Float;
	import common.system.io.binary.Short;
	import common.system.io.binary.UByte;
	import common.system.io.binary.UShort;
	import common.system.io.serialization.binary.BinaryReader;
	import common.system.TypeObject;
	import flash.utils.ByteArray;
	
	/**
	 * ...
	 * @author dorofiy.com
	 */
	public class ProtocolReader extends BinaryReader implements IDisposable
	{
		//--------------------------------------------------------------------------
		//     
		//	PROTECTED VARIABLES 
		//     
		//--------------------------------------------------------------------------
		
		protected var _protocol:Protocol;
		protected var _typeInfo:ProtocolType;
		protected var _buffer:ByteArray;
		protected var _endian:EndianEnum;
		
		//----------------------------------
		//	CONSTRUCTOR
		//----------------------------------
		
		public function ProtocolReader(protocol:Protocol, endian:EndianEnum)
		{
			this._protocol = protocol;
			this._endian = endian;
		}
		
		//--------------------------------------------------------------------------
		//     
		//	PUBLIC PROPERTIES 
		//     
		//--------------------------------------------------------------------------
		
		/**
		 *
		 */
		public function get endian():EndianEnum
		{
			return _endian;
		}
		
		//--------------------------------------------------------------------------
		//     
		//	PUBLIC METHODS 
		//     
		//--------------------------------------------------------------------------
		
		/**
		 *
		 * @param	buffer
		 * @return
		 */
		public override function read(buffer:ByteArray):Object
		{
			this._buffer = buffer;
			this._buffer.endian = _endian.toString();
			this._typeInfo = _protocol.readExtension(buffer);
			var result:Object = readBuffer(_typeInfo, buffer, _protocol);
			return result;
		}
		
		/* INTERFACE common.system.IDisposable */
		
		public function dispose():void
		{
			_protocol = null;
			_typeInfo = null;
			_buffer = null;
			_endian = null;
		}
		
		//--------------------------------------------------------------------------
		//     
		//	PROTECTED METHODS 
		//     
		//--------------------------------------------------------------------------
		
		protected function readBuffer(typeInfo:ProtocolType, buffer:ByteArray, protocol:Protocol):Object
		{
			var result:Object;
			switch (typeInfo.type)
			{
				case Boolean: 
					result = readBoolean(buffer);
					break;
				case int: 
					result = readAsInt(buffer, typeInfo.metaType);
					break;
				case uint: 
					result = readAsUInt(buffer, typeInfo.metaType);
					break;
				case Number: 
					result = readAsDouble(buffer, typeInfo.metaType);
					break;
				case String: 
					result = readString(buffer);
					break;
				case ByteArray: 
					result = readByteArray(buffer);
					break;
				case XML: 
					result = readXML(buffer);
					break;
				case XMLList: 
					result = readXMLList(buffer);
					break;
				default: 
					result = readType(buffer, typeInfo);
					break;
			}
			return result;
		}
		
		protected function readXMLList(buffer:ByteArray):XMLList
		{
			return XMLList(readString(buffer));
		}
		
		protected function readXML(buffer:ByteArray):XML
		{
			return XML(readString(buffer));
		}
		
		protected function readAsInt(buffer:ByteArray, metaType:Class):int
		{
			var result:int;
			switch (metaType)
			{
				case Byte: 
					result = readByte(buffer);
					break;
				case Short: 
					result = readShort(buffer);
					break;
				default: 
					result = readInt(buffer);
					break;
			}
			return result;
		}
		
		protected function readAsUInt(buffer:ByteArray, metaType:Class):uint
		{
			var result:uint;
			switch (metaType)
			{
				case UByte: 
					result = readUByte(buffer);
					break;
				case UShort: 
					result = readUShort(buffer);
					break;
				default: 
					result = readUint(buffer);
					break;
			}
			return result;
		}
		
		protected function readAsDouble(buffer:ByteArray, metaType:Class):Number
		{
			var result:Number;
			switch (metaType)
			{
				case Float: 
					result = readFloat(buffer);
					break;
				default: 
					result = readDouble(buffer);
					break;
			}
			return result;
		}
		
		protected function readBoolean(buffer:ByteArray):Boolean
		{
			return Boolean(buffer.readBoolean());
		}
		
		protected function readInt(buffer:ByteArray):int
		{
			return int(buffer.readInt());
		}
		
		protected function readUint(buffer:ByteArray):uint
		{
			return uint(buffer.readUnsignedInt());
		}
		
		protected function readDouble(buffer:ByteArray):Number
		{
			return Number(buffer.readDouble());
		}
		
		protected function readFloat(buffer:ByteArray):Number
		{
			return Number(buffer.readFloat());
		}
		
		protected function readByte(buffer:ByteArray):int
		{
			return int(buffer.readByte());
		}
		
		protected function readUByte(buffer:ByteArray):int
		{
			return uint(buffer.readUnsignedByte());
		}
		
		protected function readShort(buffer:ByteArray):int
		{
			return int(buffer.readShort());
		}
		
		protected function readUShort(buffer:ByteArray):uint
		{
			return uint(buffer.readUnsignedShort());
		}
		
		protected function readIsNull(buffer:ByteArray):Boolean
		{
			return buffer.readByte() == 0;
		}
		
		protected function readByteArray(buffer:ByteArray):ByteArray
		{
			if (readIsNull(buffer))
			{
				return null;
			}
			var length:int = buffer.readInt();
			var result:ByteArray = new ByteArray();
			buffer.readBytes(result, 0, length);
			return result;
		}
		
		protected function readString(buffer:ByteArray):String
		{
			if (readIsNull(buffer))
			{
				return null;
			}
			var length:int = buffer.readInt();
			return String(buffer.readUTFBytes(length));
		}
		
		protected function readVector(buffer:ByteArray, typeInfo:ProtocolType):Object
		{
			if (readIsNull(buffer))
			{
				return null;
			}
			var i:int;
			var result:Object = new typeInfo.type;
			var length:int = buffer.readInt();
			var itemType:ProtocolType = _protocol.getProtocolType(typeInfo.itemType);
			for (i = 0; i < length; i++)
			{
				result[i] = readBuffer(itemType, buffer, _protocol);
			}
			return result;
		}
		
		protected function readObject(buffer:ByteArray, typeInfo:ProtocolType):Object
		{
			if (readIsNull(buffer))
			{
				return null;
			}
			var result:Object;
			var i:int;
			var current:ProtocolType;
			var members:Vector.<ProtocolType> = typeInfo.members;
			var length:int = members.length;
			result = new typeInfo.type;
			for (i = 0; i < length; i++)
			{
				current = members[i];
				result[current.name] = readBuffer(current, buffer, _protocol);
			}
			return result;
		}
		
		protected function readType(buffer:ByteArray, typeInfo:ProtocolType):Object
		{
			var result:Object;
			if (typeInfo.itemType)
			{
				result = readVector(buffer, typeInfo);
			}
			else
			{
				result = readObject(buffer, typeInfo);
			}
			return result;
		}
	}
}