package common.system.io.serialization.binary.protocol
{
	import common.system.ClassType;
	import common.system.IDisposable;
	import common.system.io.binary.Byte;
	import common.system.io.binary.Float;
	import common.system.io.binary.Short;
	import common.system.io.binary.UByte;
	import common.system.reflection.Access;
	import common.system.reflection.Field;
	import common.system.reflection.MetaData;
	import common.system.reflection.Property;
	import common.system.Type;
	import common.system.TypeObject;
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.EventDispatcher;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import flash.xml.XMLNode;
	
	/**
	 * ...
	 * @author dorofiy.com
	 */
	public class Protocol extends TypeObject implements IDisposable
	{
		//--------------------------------------------------------------------------
		//     
		//	PRIVATE CONSTANTS 
		//     
		//--------------------------------------------------------------------------
		
		private static const VECTOR:String = "__AS3__.vec::Vector.";
		private static const LEFT_BR:String = "<";
		private static const RIGHT_BR:String = ">";
		private static const READONLY:String = "readonly";
		private static const READWRITE:String = "readwrite";
		
		//--------------------------------------------------------------------------
		//     
		//	PRIVATE VARIABLES 
		//     
		//--------------------------------------------------------------------------
		
		private var _hash:Dictionary;
		private var _extension:Dictionary;
		private var _extensionType:Dictionary;
		private var _metaNames:Vector.<String>;
		private var _metaTypes:Vector.<Class>;
		private var _excludeClass:Vector.<Class>;
		
		//----------------------------------
		//	CONSTRUCTOR
		//----------------------------------
		
		public function Protocol()
		{
			_hash = new Dictionary();
			_extension = new Dictionary();
			_extensionType = new Dictionary();
			
			_metaNames = new <String>["Byte", "UByte", "Short", "Float"];
			_metaTypes = new <Class>[Byte, UByte, Short, Float];
			
			_excludeClass = new <Class>[DisplayObject, DisplayObjectContainer, InteractiveObject, Sprite, Stage, EventDispatcher, XMLNode, Array];
		}
		
		//--------------------------------------------------------------------------
		//     
		//	PUBLIC METHODS 
		//     
		//--------------------------------------------------------------------------
		
		/**
		 *
		 * @param	value
		 * @param	type
		 */
		public function register(id:Object, type:Class):void
		{
			_register(type);
			_extension[id] = type;
			_extensionType[type] = id;
		}
		
		/**
		 *
		 * @param	buffer
		 * @return
		 */
		public function readExtension(buffer:ByteArray):ProtocolType
		{
			var index:int = buffer.readInt();
			return getProtocolType(_extension[index]);
		}
		
		/**
		 *
		 * @param	buffer
		 * @param	type
		 */
		public function writeExtension(buffer:ByteArray, type:Class):void
		{
			var index:Number = _extensionType[type];
			if (index != index)
			{
				throw new ArgumentError(ClassType.getQualifiedClassName(this) + ", type not registered, Register type before use");
			}
			buffer.writeInt(int(index));
		}
		
		/**
		 *
		 * @param	type
		 * @return
		 */
		public function getProtocolType(type:Object):ProtocolType
		{
			type = _getClassByInstance(type);
			return _hash[type];
		}
		
		/* INTERFACE common.system.IDisposable */
		
		public function dispose():void
		{
			_hash = null;
			_extension = null;
			_extensionType = null;
			_metaNames = null;
			_metaTypes = null;
			_excludeClass = null;
		}
		
		//--------------------------------------------------------------------------
		//     
		//	PRIVATE METHODS 
		//     
		//--------------------------------------------------------------------------
		
		private function _getClassByInstance(object:Object):Class
		{
			if (object is Class)
			{
				return Class(object);
			}
			var type:String = getQualifiedClassName(object);
			var result:Class = Class(getDefinitionByName(type));
			return result;
		}
		
		private function _register(type:Class, metaType:Class = null):void
		{
			if (type in _hash)
			{
				return;
			}
			
			var result:ProtocolType;
			switch (type)
			{
				case Object: 
					throw new ArgumentError(ClassType.getQualifiedClassName(this) + ", " + Object + ": not supported");
				case int: 
				case uint: 
				case Number: 
				case Boolean: 
				case String: 
				case ByteArray: 
				case XML: 
				case XMLList: 
					result = new ProtocolType();
					result.type = type;
					_hash[type] = result;
					return;
			}
			
			var factory:Type = ClassType.getType(type).instanceType;
			for each (var currentExcludeClass:Class in _excludeClass)
			{
				if (factory.isSubclassOf(currentExcludeClass) || type == currentExcludeClass)
				{
					throw new ArgumentError(ClassType.getQualifiedClassName(this) + ", not support extend class: " + currentExcludeClass);
				}
			}
			
			var list:Vector.<ProtocolType> = new Vector.<ProtocolType>();
			
			result = new ProtocolType();
			result.type = type;
			result.members = list;
			
			_hash[type] = result;
			
			if (_isVector(type) == false)
			{
				var current:ProtocolType;
				var memberName:String;
				var memberType:Class;
				var memberMeta:Class;
				var memberItem:Class;
				for each (var variable:Field in factory.fields)
				{
					memberName = variable.name;
					memberType = variable.type;
					memberMeta = _getMetaType(variable.metaData);
					memberItem = null;
					if (_isVector(memberType))
					{
						memberItem = _getVectorType(memberType);
						_register(memberItem);
					}
					_register(memberType);
					list[list.length] = getProtocolType(memberType).asMember(memberName, memberItem, memberMeta);
				}
				for each (var accessor:Property in factory.properties)
				{
					if (accessor.access == Access.READWRITE)
					{
						memberName = accessor.name;
						memberType = accessor.type;
						memberMeta = _getMetaType(accessor.metaData);
						memberItem = null;
						if (_isVector(memberType))
						{
							memberItem = _getVectorType(memberType);
							_register(memberItem);
						}
						_register(memberType, memberMeta);
						list[list.length] = getProtocolType(memberType).asMember(memberName, memberItem, memberMeta);
					}
				}
				list.sort(_sortProtocolType);
			}
		}
		
		private function _getMetaType(metaData:Vector.<MetaData>):Class
		{
			for each (var item:MetaData in metaData)
			{
				var index:int = _metaNames.indexOf(item.name);
				if (index != -1)
				{
					return _metaTypes[index];
				}
			}
			return null;
		}
		
		private static function _isVector(type:Class):Boolean
		{
			var cls:String = getQualifiedClassName(type);
			if (cls.indexOf(VECTOR) == 0)
			{
				return true
			}
			return false;
		}
		
		private static function _isVectorByName(name:String):Boolean
		{
			if (name.indexOf(VECTOR) == 0)
			{
				return true
			}
			return false;
		}
		
		private static function _getVectorType(type:Class):Class
		{
			var cls:String = getQualifiedClassName(type);
			var left:int = cls.indexOf(LEFT_BR);
			var right:int = cls.lastIndexOf(RIGHT_BR);
			if (left >= right)
			{
				throw new Error(String(type));
			}
			var result:Class = getDefinitionByName(cls.substring(left + 1, right)) as Class;
			return result;
		}
		
		private function _checkExcludeClass(xml:XMLList):Class
		{
			for each (var x:XML in xml)
			{
				var type:String = String(x.@type);
				if (_isVectorByName(type))
				{
					return null;
				}
				var clazz:Class = Class(getDefinitionByName(type));
				if (_excludeClass.indexOf(clazz) != -1)
				{
					return clazz;
				}
			}
			return null;
		}
		
		private static function _sortProtocolType(type1:ProtocolType, type2:ProtocolType):int
		{
			if (type1.name > type2.name)
			{
				return 1;
			}
			if (type1.name < type2.name)
			{
				return -1;
			}
			return 0;
		}
	}
}