package common.system.io.serialization.binary.protocol
{
	import common.system.IDisposable;
	import common.system.io.binary.Byte;
	import common.system.io.binary.EndianEnum;
	import common.system.io.binary.Float;
	import common.system.io.binary.Short;
	import common.system.io.binary.UByte;
	import common.system.io.binary.UShort;
	import common.system.io.serialization.binary.BinaryWriter;
	import common.system.TypeObject;
	import flash.utils.ByteArray;
	
	/**
	 * ...
	 * @author dorofiy.com
	 */
	public class ProtocolWriter extends BinaryWriter implements IDisposable
	{
		//--------------------------------------------------------------------------
		//     
		//	PRIVATE VARIABLES 
		//     
		//--------------------------------------------------------------------------
		
		private var _tempBuffer:ByteArray;
		
		//--------------------------------------------------------------------------
		//     
		//	PROTECTED VARIABLES 
		//     
		//--------------------------------------------------------------------------
		
		protected var _protocol:Protocol;
		protected var _endian:EndianEnum;
		protected var _typeInfo:ProtocolType;
		protected var _object:Object;
		protected var _buffer:ByteArray;
		
		//----------------------------------
		//	CONSTRUCTOR
		//----------------------------------
		
		public function ProtocolWriter(protocol:Protocol, endian:EndianEnum)
		{
			this._tempBuffer = new ByteArray();
			this._protocol = protocol;
			this._endian = endian;
		}
		
		//--------------------------------------------------------------------------
		//     
		//	PUBLIC PROPERTIES 
		//     
		//--------------------------------------------------------------------------
		
		public function get endian():EndianEnum
		{
			return _endian;
		}
		
		//--------------------------------------------------------------------------
		//     
		//	PUBLIC METHODS 
		//     
		//--------------------------------------------------------------------------
		
		public override function write(object:Object):ByteArray
		{
			this._object = object;
			this._buffer = new ByteArray();
			this._buffer.endian = this._endian.toString();
			this._typeInfo = this._protocol.getProtocolType(this._object);
			this._protocol.writeExtension(this._buffer, this._typeInfo.type);
			this.writeBuffer(this._buffer, this._typeInfo, this._object);
			return this._buffer;
		}
		
		/* INTERFACE common.system.IDisposable */
		
		public function dispose():void
		{
			_protocol = null;
			_endian = null;
			_typeInfo = null;
			_object = null;
			_buffer = null;
		}
		
		//--------------------------------------------------------------------------
		//     
		//	PROTECTED METHODS 
		//     
		//--------------------------------------------------------------------------
		
		protected function writeBuffer(buffer:ByteArray, typeInfo:ProtocolType, object:Object):void
		{
			switch (typeInfo.type)
			{
				case Boolean: 
					writeBoolean(buffer, Boolean(object));
					break;
				case int: 
					writeAsInt(buffer, object, typeInfo.metaType);
					break;
				case uint: 
					writeAsUInt(buffer, object, typeInfo.metaType);
					break;
				case Number: 
					writeAsDouble(buffer, object, typeInfo.metaType);
					break;
				case String: 
					writeString(buffer, object as String);
					break;
				case ByteArray: 
					writeByteArray(buffer, object as ByteArray);
					break;
				case XML: 
					writeXML(buffer, object as XML);
					break;
				case XMLList: 
					writeXMLList(buffer, object as XMLList);
					break;
				default: 
					writeType(buffer, typeInfo, object);
					break;
			}
		}
		
		protected function writeXML(buffer:ByteArray, xml:XML):void
		{
			writeString(buffer, xml.toXMLString());
		}
		
		protected function writeXMLList(buffer:ByteArray, xmlList:XMLList):void
		{
			writeString(buffer, xmlList.toXMLString());
		}
		
		protected function writeAsDouble(buffer:ByteArray, object:Object, metaType:Class):void
		{
			switch (metaType)
			{
				case Float: 
					writeFloat(buffer, Number(object));
					break;
				default: 
					writeDouble(buffer, Number(object));
					break;
			}
		}
		
		protected function writeAsUInt(buffer:ByteArray, object:Object, metaType:Class):void
		{
			switch (metaType)
			{
				case UByte: 
					writeUByte(buffer, int(object));
					break;
				case UShort: 
					writeUShort(buffer, int(object));
					break;
				default: 
					writeUInt(buffer, uint(object));
					break;
			}
		}
		
		protected function writeAsInt(buffer:ByteArray, object:Object, metaType:Class):void
		{
			switch (metaType)
			{
				case Byte: 
					writeByte(buffer, int(object));
					break;
				case Short: 
					writeShort(buffer, int(object));
					break;
				default: 
					writeInt(buffer, int(object));
					break;
			}
		}
		
		protected function writeBoolean(buffer:ByteArray, value:Boolean):void
		{
			buffer.writeBoolean(value);
		}
		
		protected function writeInt(buffer:ByteArray, value:int):void
		{
			buffer.writeInt(value);
		}
		
		protected function writeUInt(buffer:ByteArray, value:uint):void
		{
			buffer.writeUnsignedInt(value);
		}
		
		protected function writeDouble(buffer:ByteArray, value:Number):void
		{
			buffer.writeDouble(value);
		}
		
		protected function writeFloat(buffer:ByteArray, value:Number):void
		{
			buffer.writeFloat(value);
		}
		
		protected function writeByte(buffer:ByteArray, value:int):void
		{
			buffer.writeByte(value);
		}
		
		protected function writeUByte(buffer:ByteArray, value:int):void
		{
			buffer.writeByte(value);
		}
		
		protected function writeShort(buffer:ByteArray, value:int):void
		{
			buffer.writeShort(value);
		}
		
		protected function writeUShort(buffer:ByteArray, value:int):void
		{
			buffer.writeShort(value);
		}
		
		protected function writeIsNull(buffer:ByteArray, value:Object):Boolean
		{
			if (value == null)
			{
				buffer.writeByte(0);
				return true;
			}
			buffer.writeByte(1);
			return false;
		}
		
		protected function writeByteArray(buffer:ByteArray, bytes:ByteArray):void
		{
			if (writeIsNull(buffer, bytes))
			{
				return;
			}
			var length:int = bytes.length;
			buffer.writeInt(length);
			if (length > 0)
			{
				buffer.writeBytes(bytes, 0, length);
			}
		}
		
		protected function writeString(buffer:ByteArray, value:String):void
		{
			if (writeIsNull(buffer, value))
			{
				return;
			}
			
			_tempBuffer.clear();
			_tempBuffer.endian = buffer.endian;
			_tempBuffer.writeUTFBytes(value);
			writeInt(buffer, _tempBuffer.length);
			buffer.writeBytes(_tempBuffer, 0, _tempBuffer.length);
			_tempBuffer.clear();
		}
		
		protected function writeVector(buffer:ByteArray, typeInfo:ProtocolType, object:Object):void
		{
			if (writeIsNull(buffer, object))
			{
				return;
			}
			var length:int = object.length;
			var itemType:ProtocolType = _protocol.getProtocolType(typeInfo.itemType);
			writeInt(buffer, length);
			for (var i:int = 0; i < length; i++)
			{
				writeBuffer(buffer, itemType, object[i]);
			}
		}
		
		protected function writeObject(buffer:ByteArray, typeInfo:ProtocolType, object:Object):void
		{
			if (writeIsNull(buffer, object))
			{
				return;
			}
			var members:Vector.<ProtocolType> = typeInfo.members;
			var length:int = members.length;
			var current:ProtocolType;
			for (var i:int = 0; i < length; i++)
			{
				current = members[i];
				writeBuffer(buffer, current, object[current.name]);
			}
		}
		
		protected function writeType(buffer:ByteArray, typeInfo:ProtocolType, object:Object):void
		{
			if (typeInfo.itemType)
			{
				writeVector(buffer, typeInfo, object);
			}
			else
			{
				writeObject(buffer, typeInfo, object);
			}
		}
	}
}