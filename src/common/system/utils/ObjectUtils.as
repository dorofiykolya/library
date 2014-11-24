package common.system.utils
{
	import common.system.Cache;
	import common.system.ClassType;
	import common.system.reflection.Access;
	import common.system.reflection.Constant;
	import common.system.reflection.Field;
	import common.system.reflection.Method;
	import common.system.reflection.Property;
	import common.system.Type;
	import flash.system.ApplicationDomain;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	import flash.xml.XMLNode;
	
	/**
	 * ...
	 * @author dorofiy.com
	 */
	public class ObjectUtils
	{
		//--------------------------------------------------------------------------
		//     
		//	PRIVATE CONSTANTS 
		//     
		//--------------------------------------------------------------------------
		
		private static const CLONE_BYTE_ARRAY:ByteArray = new ByteArray();
		private static const VECTOR:String = "__AS3__.vec::Vector.";
		private static const LEFT_BR:String = "<";
		private static const RIGHT_BR:String = ">";
		private static const TYPE_NAME:String = ClassType.getQualifiedClassName(ObjectUtils);
		private static const CACHE:Cache = Cache.cache;
		private static function get typeCache():Object
		{
			return CACHE[TYPE_NAME] || (CACHE[TYPE_NAME] = new Dictionary());
		}
		
		//--------------------------------------------------------------------------
		//     
		//	PUBLIC CONSTANTS 
		//     
		//--------------------------------------------------------------------------
		
		public static const ALL_FLAG:uint = 0x3F;
		public static const FIELD_FLAG:uint = 0x1;
		public static const METHOD_FLAG:uint = 0x2;
		public static const PROPERTY_READ_FLAG:uint = 0x4;
		public static const PROPERTY_WRITE_FLAG:uint = 0x8;
		public static const CONSTANT_FLAG:uint = 0x10;
		public static const DYNAMIC_FLAG:uint = 0x20;
		public static const PROXY_FLAG:uint = 0x40;
		
		//----------------------------------
		//	CONSTRUCTOR
		//----------------------------------
		
		public function ObjectUtils()
		{
		
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
		 * @param	domain
		 * @return
		 */
		public static function clone(value:Object, type:Class = null, domain:ApplicationDomain = null):Object
		{
			var result:Object;
			CLONE_BYTE_ARRAY.clear();
			CLONE_BYTE_ARRAY.writeObject(value);
			CLONE_BYTE_ARRAY.position = 0;
			result = CLONE_BYTE_ARRAY.readObject();
			if (type == null)
			{
				type = ClassType.getClass(value);
			}
			if (type != null)
			{
				result = toType(value, type, domain);
			}
			return result;
		}
		
		/**
		 *
		 * @param	value
		 * @return
		 */
		public static function toObject(value:Object):Object
		{
			if (value == null)
			{
				return null;
			}
			
			if ((value is Class) == false)
			{
				return value;
			}
			
			var type:String = typeof(value);
			var result:Object;
			switch (type)
			{
				case "boolean": 
				case "number": 
				case "string": 
					return value;
				case "object": 
					if (value is Date)
					{
						return value.toString();
					}
					else if (value is XMLNode)
					{
						return value.toString();
					}
					else
					{
						if (value is Array || isVector(value))
						{
							var i:int;
							var len:int;
							len = value.length;
							result = new Array(len);
							for (i = 0; i < len; i++)
							{
								result[i] = toObject(value[i]);
							}
						}
						else
						{
							result = {};
							var memberNames:Object = getNamesOfMembers(value, FIELD_FLAG | PROPERTY_READ_FLAG | CONSTANT_FLAG | DYNAMIC_FLAG);
							for each (var prop:String in memberNames)
							{
								result[prop] = toObject(value[prop]);
							}
						}
						return result;
					}
					break;
				case "xml": 
					return value.toXMLString();
				default: 
					return value;
			}
			return null;
		}
		
		/**
		 *
		 * @param	value
		 * @param	maxInspectIndent
		 * @return
		 */
		public static function toString(value:Object = null, maxInspectIndent:int = 20):String
		{
			return inspect(value, 0, 5, maxInspectIndent);
		}
		
		/**
		 *
		 * @param	value
		 * @return
		 */
		public static function isVector(value:Object):Boolean
		{
			var cls:String = ClassType.getQualifiedClassName(value);
			if (cls.indexOf(VECTOR) == 0)
			{
				return true;
			}
			return false;
		}
		
		/**
		 *
		 * @param	value
		 * @return
		 */
		public static function isPrimitive(value:Object):Boolean
		{
			if (value)
			{
				var type:Class = ClassType.getClass(value);
				switch (type)
				{
					case String: 
					case Boolean: 
					case int: 
					case uint: 
					case Boolean: 
						return true;
				}
			}
			return false;
		}
		
		/**
		 *
		 * @param	value
		 * @param	flags ObjectUtils (FIELD_FLAG | METHOD_FLAG | PROPERTY_READ_FLAG | PROPERTY_WRITE_FLAG | CONSTANT_FLAG | DYNAMIC_FLAG)
		 * @return
		 */
		public static function getNamesOfMembers(value:Object, flags:int = ALL_FLAG):Vector.<String>
		{
			if (value == null)
			{
				return null;
			}
			
			var hasField:Boolean = BitFlagUtil.getFlag(flags, FIELD_FLAG);
			var hasMethod:Boolean = BitFlagUtil.getFlag(flags, METHOD_FLAG);
			var hasReadProperty:Boolean = BitFlagUtil.getFlag(flags, PROPERTY_READ_FLAG);
			var hasWriteProperty:Boolean = BitFlagUtil.getFlag(flags, PROPERTY_WRITE_FLAG);
			var hasConstant:Boolean = BitFlagUtil.getFlag(flags, CONSTANT_FLAG);
			var hasDynamic:Boolean = BitFlagUtil.getFlag(flags, DYNAMIC_FLAG);
			var hasProxy:Boolean = BitFlagUtil.getFlag(flags, PROXY_FLAG);
			
			var result:Vector.<String> = new Vector.<String>();
			var type:Type = ClassType.getType(value);
			if (hasField)
			{
				for each (var field:Field in type.fields)
				{
					result[result.length] = field.name;
				}
			}
			if (hasMethod)
			{
				for each (var method:Method in type.methods)
				{
					result[result.length] = method.name;
				}
			}
			if (hasReadProperty || hasWriteProperty)
			{
				for each (var property:Property in type.properties)
				{
					if (property.access == Access.READWRITE)
					{
						result[result.length] = property.name;
					}
					else
					{
						if (hasReadProperty && property.access == Access.READONLY)
						{
							result[result.length] = property.name;
						}
						if (hasWriteProperty && property.access == Access.WRITEONLY)
						{
							result[result.length] = property.name;
						}
					}
				}
			}
			if (hasConstant)
			{
				for each (var constant:Constant in type.constants)
				{
					result[result.length] = constant.name;
				}
			}
			if (hasDynamic && (type.isDynamic || type.isProxy))
			{
				for (var name:String in value)
				{
					result[result.length] = name;
				}
			}
			return result;
		}
		
		/**
		 *
		 * @param	value
		 * @param	type
		 * @param	domain
		 * @return
		 */
		public static function toType(value:Object, type:Class, domain:ApplicationDomain = null):Object
		{
			if (domain == null)
			{
				domain = ApplicationDomain.currentDomain;
			}
			return _parse(value, type, null, domain);
		}
		
		/**
		 *
		 * @param	type
		 * @param	domain
		 */
		public static function registerType(type:Class, domain:ApplicationDomain = null):void
		{
			if (type in typeCache)
			{
				return;
			}
            if (domain == null)
            {
                domain = ApplicationDomain.currentDomain;
            }
			_register(type, domain);
		}
		
		//--------------------------------------------------------------------------
		//     
		//	PRIVATE METHODS 
		//     
		//--------------------------------------------------------------------------
		
		private static function inspect(value:*, indent:int = 0, indentation:int = 5, maxInspectIndent:int = 20):String
		{
			var result:String;
			var type:String;
			if (value == undefined)
			{
				type = "undefined";
			}
			else if (value == null)
			{
				type = "null";
			}
			else
			{
				type = typeof(value);
			}
			
			switch (type)
			{
				case "boolean": 
				case "number": 
					return String(value);
				case "string": 
					return "\"" + String(value) + "\"";
				case "object": 
					if (value is Date)
					{
						return value.toString();
					}
					else if (value is XMLNode)
					{
						return value.toString();
					}
					else if (value is Class)
					{
						return "(" + ClassType.getQualifiedClassName(value) + ")";
					}
					else
					{
						var isArray:Boolean = value is Array;
						var isDict:Boolean = value is Dictionary;
						var classType:String = ClassType.getQualifiedClassName(value);
						var i:int;
						result = "(" + classType + ")";
						
						indent += indentation;
						if (indent < maxInspectIndent)
						{
							var memberFields:Vector.<String> = getNamesOfMembers(value, FIELD_FLAG | PROPERTY_READ_FLAG | CONSTANT_FLAG | DYNAMIC_FLAG);
							for each (var prop:String in memberFields)
							{
								result += "\n";
								for (i = 0; i < indent; i++)
								{
									result += " ";
								}
								
								if (isArray)
								{
									result += "[";
								}
								else if (isDict)
								{
									result += "{";
								}
								
								if (isDict)
								{
									result += inspect(prop, indent, indentation, maxInspectIndent);
								}
								else
								{
									result += prop.toString();
								}
								
								if (isArray)
								{
									result += "]";
								}
								else if (isDict)
								{
									result += "} = ";
								}
								else
								{
									result += " = ";
								}
								
								try
								{
									result += inspect(value[prop], indent, indentation, maxInspectIndent);
								}
								catch (e:Error)
								{
									result += "?";
								}
							}
						}
						else
						{
							result += "\n";
							for (i = 0; i < indent; i++)
							{
								result += " ";
							}
							result += "ERROR maxInspectIndent";
						}
						
						indent -= indentation;
						return result;
					}
					break;
				case "xml": 
					return value.toXMLString();
				default: 
					return "(" + type + ")";
			}
			return "(unknow)";
		}
		
		private static function _register(type:Class, domain:ApplicationDomain):TypeInfo
		{
			var typeInfo:TypeInfo;
			var xml:XML;
			var variable:Object;
			var accessor:Object;
			var typeName:String;
			var vectorLeft:int;
			var vectorRight:int;
			var field:Field;
			var property:Property;
			var typeInfoFields:Vector.<TypeInfo>;
			
			typeInfo = new TypeInfo();
			typeInfo.type = type;
			typeCache[type] = typeInfo;
			switch (type)
			{
				case Boolean: 
				case Number: 
				case int: 
				case uint: 
				case String: 
				case Object: 
					typeInfo.isSimple = true;
					return typeInfo;
					break;
				case Array: 
					typeInfo.isArray = true;
					return typeInfo;
					break;
			}
			
			var refType:Type = ClassType.getType(type, domain).instanceType;
			typeName = refType.qualifiedClassName;
			if (refType.isVector)
			{
				typeInfo.isVector = true;
				vectorLeft = typeName.indexOf(LEFT_BR);
				vectorRight = typeName.lastIndexOf(RIGHT_BR);
				if (vectorLeft >= vectorRight)
				{
					throw new Error(Type + ":" + type);
				}
				typeInfo.vectorType = getDefinitionByName(domain, typeName.substring(vectorLeft + 1, vectorRight)) as Class;
				_register(typeInfo.vectorType, domain);
				
				return typeInfo;
			}
			
			typeInfoFields = new Vector.<TypeInfo>();
			typeInfo.fields = typeInfoFields;
			
			for each (field in refType.fields)
			{
				typeInfoFields[typeInfoFields.length] = _getTypeInfo(field.type, domain).clone(field.name);
			}
			
			for each (property in refType.properties)
			{
				if (property.access == Access.READONLY)
				{
					continue;
				}
				typeInfoFields[typeInfoFields.length] = _getTypeInfo(property.type, domain).clone(property.name);
			}
			return typeInfo;
		}
		
		[Inline]
		
		private static function _getTypeInfo(type:Class, domain:ApplicationDomain):TypeInfo
		{
			var typeInfo:TypeInfo = typeCache[type];
			if (typeInfo == null)
			{
				return _register(type, domain);
			}
			return typeInfo;
		}
		
		private static function _parse(value:*, type:Class, arrayType:Class = null, domain:ApplicationDomain = null):*
		{
			var typeInfo:TypeInfo;
			var item:TypeInfo;
			var i:int;
			var len:int;
			var result:Object;
			var index:String;
			
			if (type == null)
			{
				return value;
			}
			if (value === undefined)
			{
				return undefined;
			}
			if (value === null)
			{
				return null;
			}
			typeInfo = typeCache[type];
			if (typeInfo == null)
			{
				registerType(type);
				typeInfo = typeCache[type];
			}
			if (typeInfo.isSimple)
			{
				return typeInfo.type(value);
			}
			if (typeInfo.isArray)
			{
				len = value.length;
				result = new Array(len);
				for (i = 0; i < len; i++)
				{
					result[i] = _parse(value[i], arrayType, null, domain);
				}
				return result;
			}
			if (typeInfo.isVector)
			{
				len = value.length;
				result = new typeInfo.type(len);
				for (i = 0; i < len; i++)
				{
					result[i] = _parse(value[i], typeInfo.vectorType, null, domain);
				}
				return result;
			}
			if (typeInfo.isDictionary)
			{
				result = new Dictionary();
				for (index in value)
				{
					result[index] = value[index];
				}
				return result;
			}
			result = new typeInfo.type;
			for each (item in typeInfo.fields)
			{
				result[item.name] = _parse(value[item.name], item.type, null, domain);
			}
			return result;
		}
	}
}

class TypeInfo
{
	public var isVector:Boolean;
	public var isArray:Boolean;
	public var isSimple:Boolean;
	public var isDictionary:Boolean;
	
	public var vectorType:Class;
	public var type:Class;
	
	public var fields:Vector.<TypeInfo>;
	public var name:String;
	
	public function TypeInfo()
	{
	
	}
	
	public function clone(name:String):TypeInfo
	{
		var result:TypeInfo = new TypeInfo();
		result.name = name;
		result.isVector = isVector;
		result.isArray = isArray;
		result.isSimple = isSimple;
		result.isDictionary = isDictionary;
		result.vectorType = vectorType;
		result.type = type;
		result.fields = fields;
		return result;
	}
}