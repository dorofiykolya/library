package common.system.reflection
{
	import avmplus.AVMPlus;
	import common.system.ClassType;
	import common.system.TypeObject;
	import common.system.utils.getDefinitionByName;
	import common.system.utils.ObjectUtils;
	import flash.system.ApplicationDomain;
	import flash.utils.Dictionary;
	import flash.utils.getQualifiedClassName;
	import flash.utils.Proxy;
	
	/**
	 * ...
	 * @author dorofiy.com
	 */
	public class Reflection extends TypeObject
	{
		private static const VECTOR_PREFIX:String = "__AS3__.vec::Vector.";
		
		private var _value:*;
		private var _hasInstance:Boolean;
		private var _isNull:Boolean;
		private var _isUndefined:Boolean;
		private var _isDynamic:Boolean;
		private var _isVector:Boolean;
		private var _isFinal:Boolean;
		private var _isStatic:Boolean;
		private var _isFunction:Boolean;
		private var _isArray:Boolean;
		private var _isDictionary:Boolean;
		private var _isDate:Boolean;
		private var _qualifiedClassName:String;
		private var _extendsClasses:Vector.<Class>;
		private var _interfaces:Vector.<Class>;
		private var _name:String;
		private var _package:String;
		private var _class:Class;
		private var _isPrimitive:Boolean;
		private var _isXML:Boolean;
		private var _isXMLList:Boolean;
		private var _describeType:Object;
		private var _traits:Object;
		private var _isClass:Boolean;
		private var _isFactory:Boolean;
		private var _isProxy:Boolean;
		
		private var _constructor:Constructor;
		private var _parameters:Vector.<Parameter>;
		private var _constants:Vector.<Constant>;
		private var _fields:Vector.<Field>;
		private var _methods:Vector.<Method>;
		private var _properties:Vector.<Property>;
		private var _members:Vector.<Member>;
		private var _metadata:Vector.<MetaData>;
		
		private var _domain:ApplicationDomain;
		
		private var _classReflection:Reflection;
		private var _factoryReflection:Reflection;
		
		public function Reflection(value:*, domain:ApplicationDomain = null)
		{
			if (domain == null)
			{
				domain = ApplicationDomain.currentDomain;
			}
			_domain = domain;
			parseValue(value, null, _domain);
		}
		
		private function parseValue(value:*, factoryDescribeType:Object = null, domain:ApplicationDomain = null):void
		{
			_value = value;
			_isNull = value === null;
			_isUndefined = value === undefined;
			_hasInstance = !_isNull && !_isUndefined;
			_domain = domain;
			
			if (_hasInstance == false)
			{
				return;
			}
			
			_qualifiedClassName = getQualifiedClassName(_value);
			
			if (_value is Class)
			{
				_isStatic = true;
				_isClass = true;
				_class = _value;
				_isFactory = false;
			}
			else
			{
				_class = ClassType.getClass(value);
				_isFactory = true;
			}
			
			switch (_class)
			{
				case String: 
				case int: 
				case uint: 
				case Number: 
				case Boolean: 
					_isPrimitive = true;
					break;
				case Array: 
					_isArray = true;
					_isDynamic = true;
					break;
				case Dictionary: 
					_isDictionary = true;
					_isDynamic = true;
					break;
				case XML: 
					_isXML = true;
					break;
				case XMLList: 
					_isXMLList = true;
					break;
				case Function: 
					_isFunction = true;
					break;
				case Date: 
					_isDate = true;
					break;
				default: 
					_isVector = _qualifiedClassName.indexOf(VECTOR_PREFIX) == 0;
					_isFunction = _value is Function;
					_isProxy = !_isVector && !_isFunction && _value is Proxy;
					break;
			}
			
			if (factoryDescribeType)
			{
				_describeType = factoryDescribeType;
			}
			else
			{
				_describeType = AVMPlus.describeType(_value);
			}
			_name = _describeType.name;
			_traits = _describeType.traits;
			if (_name.indexOf("::") != -1)
			{
				var separate:Array = _name.split("::");
				_package = separate[0];
				_name = separate[1];
			}
			
			if (!_isDynamic)
			{
				_isDynamic = _describeType.isDynamic;
			}
			if (!_isStatic)
			{
				_isStatic = _describeType.isStatic;
			}
			_isFinal = _describeType.isFinal;
		}
		
		public final function get describeType():Object
		{
			return ObjectUtils.clone(_describeType);
		}
		
		public final function get traits():Object
		{
			return ObjectUtils.clone(_traits);
		}
		
		public final function get domain():ApplicationDomain
		{
			return _domain;
		}
		
		public final function get isEnumeration():Boolean
		{
			return _isDynamic || _isArray || _isVector || _isDictionary;
		}
		
		public final function get isFactory():Boolean
		{
			return _isFactory;
		}
		
		public final function get isClass():Boolean
		{
			return _isClass;
		}
		
		public final function get isDate():Boolean
		{
			return _isDate;
		}
		
		public final function get isXML():Boolean
		{
			return _isXML;
		}
		
		public final function get isXMLList():Boolean
		{
			return _isXMLList;
		}
		
		public final function get isPrimitive():Boolean
		{
			return _isPrimitive;
		}
		
		public final function get isArray():Boolean
		{
			return _isArray;
		}
		
		public final function get isVector():Boolean
		{
			return _isVector;
		}
		
		public final function get isDictionary():Boolean
		{
			return _isDictionary;
		}
		
		public final function get isNull():Boolean
		{
			return _isNull;
		}
		
		public final function get isUndefined():Boolean
		{
			return _isUndefined;
		}
		
		public final function get isDynamic():Boolean
		{
			return _isDynamic;
		}
		
		public final function get isFinal():Boolean
		{
			return _isFinal;
		}
		
		public final function get isStatic():Boolean
		{
			return _isStatic;
		}
		
		public final function get isFunction():Boolean
		{
			return _isFunction;
		}
		
		public final function get isProxy():Boolean
		{
			return _isProxy;
		}
		
		public final function get qualifiedClassName():String
		{
			return _qualifiedClassName;
		}
		
		public final function get packageName():String
		{
			return _package;
		}
		
		public final function get name():String
		{
			return _name;
		}
		
		public final function get classReflection():Reflection
		{
			if (_hasInstance && _classReflection == null)
			{
				if (_isClass)
				{
					_classReflection = this;
				}
				else if (_isFactory)
				{
					_classReflection = new Reflection(_class);
				}
			}
			return _classReflection;
		}
		
		public final function get factoryReflection():Reflection
		{
			if (_hasInstance && _factoryReflection == null)
			{
				if (_isFactory)
				{
					_factoryReflection = this;
				}
				else if (_isClass)
				{
					_factoryReflection = new Reflection(null);
					_factoryReflection.parseValue(_class, AVMPlus.describeInstance(_class), _domain);
				}
			}
			return _factoryReflection;
		}
		
		public final function get constructorClass():Class
		{
			return _class;
		}
		
		public final function getMetaData(name:String = null):Vector.<MetaData>
		{
			if (name == null)
			{
				return metaData;
			}
			if (_hasInstance)
			{
				var result:Vector.<MetaData> = new Vector.<MetaData>();
				for each (var item:MetaData in internalMetadata)
				{
					if (item._name == name)
					{
						result[result.length] = item;
					}
				}
				return result;
			}
			return null;
		}
		
		public final function get metaData():Vector.<MetaData>
		{
			if (_hasInstance && _metadata == null)
			{
				_metadata = internalMetadata;
			}
			return _metadata ? _metadata.slice() : null;
		}
		
		public final function getProperty(name:String):Property
		{
			if (_hasInstance)
			{
				for each (var item:Property in internalProperties)
				{
					if (item._name == name)
					{
						return item;
					}
				}
			}
			return null;
		}
		
		public final function getField(name:String):Field
		{
			if (_hasInstance)
			{
				for each (var item:Field in internalFields)
				{
					if (item.name == name)
					{
						return item;
					}
				}
			}
			return null;
		}
		
		public final function getMethod(name:String):Method
		{
			if (_hasInstance)
			{
				for each (var item:Method in internalMethods)
				{
					if (item._name == name)
					{
						return item;
					}
				}
			}
			return null;
		}
		
		public final function getMember(name:String):Member
		{
			if (_hasInstance)
			{
				for each (var item:Member in internalMembers)
				{
					if (item._name == name)
					{
						return item;
					}
				}
			}
			return null;
		}
		
		public final function getMembers(memberType:MemberType = null):Vector.<Member>
		{
			if (memberType == null)
			{
				return members;
			}
			var result:Vector.<Member> = new Vector.<Member>();
			var tempMembers:Vector.<Member> = internalMembers;
			if (tempMembers)
			{
				for each (var member:Member in tempMembers)
				{
					if (member._memberType == memberType)
					{
						result[result.length] = member;
					}
				}
			}
			return result;
		}
		
		public final function get members():Vector.<Member>
		{
			if (_hasInstance && _members == null)
			{
				_members = internalMembers;
			}
			return _members ? _members.slice() : null;
		}
		
		public final function getProperties(access:Access = null):Vector.<Property>
		{
			if (access == null)
			{
				return properties;
			}
			var result:Vector.<Property> = new Vector.<Property>();
			for each (var property:Property in internalProperties) 
			{
				if (property._access == access)
				{
					result[result.length] = property;
				}
			}
			return result;
		}
		
		public final function get properties():Vector.<Property>
		{
			if (_hasInstance && _properties == null)
			{
				_properties = internalProperties;
			}
			return _properties ? _properties.slice() : null;
		}
		
		public final function getMethods():Vector.<Method>
		{
			if (_hasInstance && _methods == null)
			{
				_methods = internalMethods;
			}
			return _methods ? _methods.slice() : null;
		}
		
		public final function get methods():Vector.<Method>
		{
			if (_hasInstance && _methods == null)
			{
				_methods = internalMethods;
			}
			return _methods ? _methods.slice() : null;
		}
		
		public final function getFields():Vector.<Field>
		{
			if (_hasInstance && _fields == null)
			{
				_fields = internalFields;
			}
			return _fields ? _fields.slice() : null;
		}
		
		public final function get fields():Vector.<Field>
		{
			if (_hasInstance && _fields == null)
			{
				_fields = internalFields;
			}
			return _fields ? _fields.slice() : null;
		}
		
		public final function get constants():Vector.<Constant>
		{
			if (_hasInstance && _constants == null)
			{
				_constants = internalConstants;
			}
			return _constants ? _constants.slice() : null;
		}
		
		public final function getConstants():Vector.<Constant>
		{
			if (_hasInstance && _constants == null)
			{
				_constants = internalConstants;
			}
			return _constants ? _constants.slice() : null;
		}
		
		public final function get constructorInfo():Constructor
		{
			if (_hasInstance && _constructor == null)
			{
				_constructor = new Constructor();
				_constructor._name = _name;
				_constructor._returnType = null;
				_constructor._type = _class;
				_constructor._declaredBy = _class;
				_constructor._metaData = internalGetMetaData(_traits.constructor);
				_constructor._parameters = internalGetParametersByArray(_traits.constructor);
			}
			return _constructor;
		}
		
		public final function getParameters():Vector.<Parameter>
		{
			return parameters;
		}
		
		public final function get parameters():Vector.<Parameter>
		{
			if (_hasInstance && _isFunction && _parameters == null)
			{
				_parameters = internalGetParameters(_describeType);
			}
			return _parameters ? _parameters.slice() : null;
		}
		
		public final function get extendsClasses():Vector.<Class>
		{
			if (_hasInstance && _extendsClasses == null)
			{
				_extendsClasses = internalExtendsClasses;
			}
			return _extendsClasses ? _extendsClasses.slice() : null;
		}
		
		public final function get interfaces():Vector.<Class>
		{
			if (_hasInstance && _interfaces == null)
			{
				_interfaces = internalInterfaces;
			}
			return _interfaces ? _interfaces.slice() : null;
		}
		
		public final function isExtendedClass(type:Class):Boolean
		{
			if (_hasInstance && type)
			{
                if (_extendsClasses)
                {
                    return _extendsClasses.indexOf(type) != -1;
                }
				return internalExtendsClasses.indexOf(type) != -1;
			}
			return false;
		}
		
		public final function isImplementedInterface(type:Class):Boolean
		{
			if (_hasInstance && type)
			{
                if (_interfaces)
                {
                    return _interfaces.indexOf(type) != -1;
                }
				return internalInterfaces.indexOf(type) != -1;
			}
			return false;
		}
		
		public final function isExtended(type:Class):Boolean
		{
			return isExtendedClass(type) || isImplementedInterface(type);
		}
		
		public final function isSubclassOf(type:Class):Boolean
		{
			if (_hasInstance && type)
			{
				return internalExtendsClasses.indexOf(type) != -1 || internalInterfaces.indexOf(type) != -1;
			}
			return false;
		}
        
        public final function isInstanceOf(type:Class):Boolean
        {
            if (_hasInstance && type)
            {
                return _class == type || isSubclassOf(type);
            }
            return false;
        }
		
		public final function newInstance(... args):Object
		{
			if (_hasInstance)
			{
				var params:Vector.<Parameter> = constructorInfo._parameters;
				if (params == null || params.length == 0)
				{
					return new _class();
				}
				if (constructorInfo.requiredParameterCount > args.length)
				{
					throw new ArgumentError(ClassType.getQualifiedClassName(this) + ", newInstance() - wrong number of arguments");
				}
				var argumentLen:int = Math.min(args.length, params.length);
				switch (argumentLen)
				{
					case 0: 
						return new _class();
					case 1: 
						return new _class(args[0]);
					case 2: 
						return new _class(args[0], args[1]);
					case 3: 
						return new _class(args[0], args[1], args[2]);
					case 4: 
						return new _class(args[0], args[1], args[2], args[3]);
					case 5: 
						return new _class(args[0], args[1], args[2], args[3], args[4]);
					case 6: 
						return new _class(args[0], args[1], args[2], args[3], args[4], args[5]);
					case 7: 
						return new _class(args[0], args[1], args[2], args[3], args[4], args[5], args[6]);
					case 8: 
						return new _class(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7]);
					case 9: 
						return new _class(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8]);
					case 10: 
						return new _class(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9]);
					case 11: 
						return new _class(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10]);
					case 12: 
						return new _class(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10], args[11]);
					case 13: 
						return new _class(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10], args[11], args[12]);
					case 14: 
						return new _class(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10], args[11], args[12], args[13]);
					case 15: 
						return new _class(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10], args[11], args[12], args[13], args[14]);
					case 16: 
						return new _class(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10], args[11], args[12], args[13], args[14], args[15]);
					case 17: 
						return new _class(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10], args[11], args[12], args[13], args[14], args[15], args[16]);
					case 18: 
						return new _class(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10], args[11], args[12], args[13], args[14], args[15], args[16], args[17]);
					case 19: 
						return new _class(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10], args[11], args[12], args[13], args[14], args[15], args[16], args[17], args[18]);
					case 20: 
						return new _class(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10], args[11], args[12], args[13], args[14], args[15], args[16], args[17], args[18], args[19]);
					case 21: 
						return new _class(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10], args[11], args[12], args[13], args[14], args[15], args[16], args[17], args[18], args[19], args[20]);
					case 22: 
						return new _class(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10], args[11], args[12], args[13], args[14], args[15], args[16], args[17], args[18], args[19], args[20], args[21]);
					case 23: 
						return new _class(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10], args[11], args[12], args[13], args[14], args[15], args[16], args[17], args[18], args[19], args[20], args[21], args[22]);
					case 24: 
						return new _class(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10], args[11], args[12], args[13], args[14], args[15], args[16], args[17], args[18], args[19], args[20], args[21], args[22], args[23]);
					case 25: 
						return new _class(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10], args[11], args[12], args[13], args[14], args[15], args[16], args[17], args[18], args[19], args[20], args[21], args[22], args[23], args[24]);
					case 26: 
						return new _class(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10], args[11], args[12], args[13], args[14], args[15], args[16], args[17], args[18], args[19], args[20], args[21], args[22], args[23], args[24], args[25]);
					case 27: 
						return new _class(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10], args[11], args[12], args[13], args[14], args[15], args[16], args[17], args[18], args[19], args[20], args[21], args[22], args[23], args[24], args[25], args[26]);
					case 28: 
						return new _class(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10], args[11], args[12], args[13], args[14], args[15], args[16], args[17], args[18], args[19], args[20], args[21], args[22], args[23], args[24], args[25], args[26], args[27]);
					case 29: 
						return new _class(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10], args[11], args[12], args[13], args[14], args[15], args[16], args[17], args[18], args[19], args[20], args[21], args[22], args[23], args[24], args[25], args[26], args[27], args[28]);
					case 30: 
						return new _class(args[0], args[1], args[2], args[3], args[4], args[5], args[6], args[7], args[8], args[9], args[10], args[11], args[12], args[13], args[14], args[15], args[16], args[17], args[18], args[19], args[20], args[21], args[22], args[23], args[24], args[25], args[26], args[27], args[28], args[29]);
				}
			}
			return null;
		}
		
		public override function toString():String
		{
			return String(_value);
		}
		
		public function get type():Class
		{
			return _class;
		}
        
        private final function get internalMethods():Vector.<Method>
		{
			if (_hasInstance && _methods == null)
			{
				_methods = new Vector.<Method>();
				var method:Method;
				for each (var current:Object in _traits.methods)
				{
					method = new Method();
					method._name = current.name;
					method._returnType = internalGetReturnType(current);
					method._nameSpace = internalGetNamespace(current);
					method._parameters = internalGetParameters(current);
					method._declaredBy = internalGetDeclaredBy(current);
					method._type = Function;
					method._metaData = internalGetMetaData(current);
					_methods[_methods.length] = method;
				}
			}
			return _methods ? _methods : null;
		}
        
        private final function get internalProperties():Vector.<Property>
        {
            if (_hasInstance && _properties == null)
			{
				_properties = new Vector.<Property>();
				var property:Property;
				for each (var current:Object in _traits.accessors)
				{
					property = new Property();
					property._name = current.name;
					property._type = internalGetType(current);
					property._declaredBy = internalGetDeclaredBy(current);
					property._nameSpace = internalGetNamespace(current);
					property._metaData = internalGetMetaData(current);
					property._access = Access.getAccess(current.access);
					_properties[_properties.length] = property;
				}
			}
			return _properties ? _properties : null;
        }
        
        private final function get internalMembers():Vector.<Member>
		{
			if (_hasInstance && _members == null)
			{
				_members = new Vector.<Member>();
				var member:Member;
				
				for each (member in internalConstants)
				{
					_members[_members.length] = member;
				}
				
				for each (member in internalFields)
				{
					_members[_members.length] = member;
				}
				
				for each (member in internalProperties)
				{
					_members[_members.length] = member;
				}
				
				for each (member in internalMethods)
				{
					_members[_members.length] = member;
				}
			}
			return _members ? _members : null;
		}
        
        private final function get internalFields():Vector.<Field>
		{
			if (_hasInstance && _fields == null)
			{
				var readOnly:String = String(Access.READONLY.value);
				
				_fields = new Vector.<Field>();
				_constants = new Vector.<Constant>();
				
				var member:Member;
				for each (var current:Object in _traits.variables)
				{
					if (current.access == readOnly)
					{
						member = new Constant();
						_constants[_constants.length] = Constant(member);
					}
					else
					{
						member = new Field();
						_fields[_fields.length] = Field(member);
					}
					
					member._name = current.name;
					member._type = internalGetType(current);
					member._metaData = internalGetMetaData(current);
					member._nameSpace = internalGetNamespace(current);
				}
			}
			return _fields ? _fields : null;
		}
        
        private final function get internalConstants():Vector.<Constant>
		{
			if (_hasInstance && _constants == null)
			{
				var readOnly:String = String(Access.READONLY.value);
				
				_fields = new Vector.<Field>();
				_constants = new Vector.<Constant>();
				
				var member:Member;
				for each (var current:Object in _traits.variables)
				{
					if (current.access == readOnly)
					{
						member = new Constant();
						_constants[_constants.length] = Constant(member);
					}
					else
					{
						member = new Field();
						_fields[_fields.length] = Field(member);
					}
					
					member._name = current.name;
					member._type = internalGetType(current);
					member._metaData = internalGetMetaData(current);
					member._nameSpace = internalGetNamespace(current);
				}
			}
			return _constants ? _constants : null;
		}
        
        private final function get internalMetadata():Vector.<MetaData>
        {
            if (_hasInstance && _metadata == null)
			{
				_metadata = internalGetMetaData(_traits);
			}
			return _metadata ? _metadata : null;
        }
        
        private final function get internalExtendsClasses():Vector.<Class>
		{
			if (_hasInstance && _extendsClasses == null)
			{
				_extendsClasses = new Vector.<Class>();
				for each (var current:Object in _traits.bases)
				{
					_extendsClasses[_extendsClasses.length] = internalGetType(current);
				}
			}
			return _extendsClasses ? _extendsClasses : null;
		}
		
		private final function get internalInterfaces():Vector.<Class>
		{
			if (_hasInstance && _interfaces == null)
			{
				_interfaces = new Vector.<Class>();
				for each (var current:Object in _traits.interfaces)
				{
					_interfaces[_interfaces.length] = internalGetType(current);
				}
			}
			return _interfaces ? _interfaces : null;
		}
		
		private function internalGetMetaData(value:Object):Vector.<MetaData>
		{
			var result:Vector.<MetaData> = new Vector.<MetaData>();
			if (value)
			{
				for each (var current:Object in value.metadata)
				{
					result[result.length] = internalExctractMetadata(current);
				}
			}
			return result;
		}
		
		private function internalExctractMetadata(value:Object):MetaData
		{
			var meta:MetaData = new MetaData();
			meta._name = value.name;
			var arg:Vector.<Argument> = new Vector.<Argument>();
			var argument:Argument;
			for each (var item:Object in value.value)
			{
				arg[arg.length] = new Argument(item.key, item.value);
			}
			meta._arguments = arg;
			return meta;
		}
		
		private function internalGetParametersByArray(value:Object):Vector.<Parameter>
		{
			var result:Vector.<Parameter> = new Vector.<Parameter>();
			var i:int = 1;
			var parameter:Parameter;
			if (value)
			{
				for each (var current:Object in value)
				{
					parameter = new Parameter();
					parameter._index = i;
					parameter._type = internalGetType(current);
					parameter._optional = current.optional;
					result[result.length] = parameter;
					i++;
				}
			}
			return result;
		}
		
		private function internalGetParameters(value:Object):Vector.<Parameter>
		{
			var result:Vector.<Parameter> = new Vector.<Parameter>();
			var i:int = 1;
			var parameter:Parameter;
			if (value)
			{
				for each (var current:Object in value.parameter)
				{
					parameter = new Parameter();
					parameter._index = i;
					parameter._type = internalGetType(current);
					parameter._optional = current.optional;
					result[result.length] = parameter;
					i++;
				}
			}
			return result;
		}
		
		private function internalGetReturnType(value:Object):Class
		{
			var type:String = value.returnType;
			if (type == "void")
			{
				return null;
			}
			return Class(getDefinitionByName(_domain, type));
		}
		
		private function internalGetDeclaredBy(value:Object):Class
		{
			var type:String = value.declaredBy;
			if (type == "*" || type == "void")
			{
				return null;
			}
			return Class(getDefinitionByName(_domain, type));
		}
		
		private function internalGetType(value:Object):Class
		{
			var type:String = value as String;
			if(type == null)
			{
				type = value.type;
			}
			if (type == "*")
			{
				return null;
			}
			return Class(getDefinitionByName(_domain, type));
		}
		
		private function internalGetNamespace(value:Object):Namespace
		{
			var uri:String = value.uri;
			if (uri)
			{
				return new Namespace(uri, uri);
			}
			return null;
		}
	}
}