package common.system
{
	import common.system.reflection.Access;
	import common.system.reflection.Constant;
	import common.system.reflection.Constructor;
	import common.system.reflection.Field;
	import common.system.reflection.Member;
	import common.system.reflection.MemberType;
	import common.system.reflection.MetaData;
	import common.system.reflection.Method;
	import common.system.reflection.Parameter;
	import common.system.reflection.Property;
	import common.system.reflection.Reflection;
	import flash.system.ApplicationDomain;
	
	/**
	 * ...
	 * @author dorofiy.com
	 */
	public class Type extends TypeObject
	{
		//--------------------------------------------------------------------------
		//     
		//	PRIVATE CONSTANTS 
		//     
		//--------------------------------------------------------------------------
		
		private static const CACHE:Cache = Cache.cache;
		
		//--------------------------------------------------------------------------
		//     
		//	PRIVATE VARIABLES 
		//     
		//--------------------------------------------------------------------------
		
		private var _reflection:Reflection;
		
		//----------------------------------
		//	CONSTRUCTOR
		//----------------------------------
		
		public function Type()
		{
			
		}
		
		//--------------------------------------------------------------------------
		//     
		//	INTERNAL SECTION 
		//     
		//--------------------------------------------------------------------------
		
		internal static function getType(value:Object, domain:ApplicationDomain = null):Type
		{
			if (value == null)
			{
				return null;
			}
			var isFactory:Boolean = !(value is Class);
			var type:Class;
			if (isFactory) 
			{
				type = ClassType.getClass(value);
			}
			else
			{
				type = Class(value);
			}
			var result:Type;
			result = CACHE.getTypeCache(type, isFactory);
			if (result == null)
			{
				result = new Type();
				result._reflection = new Reflection(value, domain);
				CACHE.setTypeCache(type, isFactory, result);
			}
			return result;
		}
		
		//--------------------------------------------------------------------------
		//     
		//	PUBLIC SECTION 
		//     
		//--------------------------------------------------------------------------
		
		public function get instanceType():Type
		{
			var result:Type = CACHE.getTypeCache(_reflection.constructorClass, true);
			if (result == null)
			{
				result = new Type();
				result._reflection = _reflection.factoryReflection;
				CACHE.setTypeCache(_reflection.constructorClass, true, result);
			}
			return result;
		}
		
		public function getInstanceType():Type
		{
			return instanceType;
		}
		
		public function getClassType():Type
		{
			return classType;
		}
		
		public function get classType():Type
		{
			return Type.getType(_reflection.constructorClass);
		}
		
		public function getFactoryType():Type
		{
			return instanceType;
		}
		
		public function get factoryType():Type
		{
			return instanceType;
		}
		
		public function newInstance(...args):Object 
		{
			return _reflection.newInstance.apply(null, args);
		}
		
		/* DELEGATE common.system.reflection.Reflection */
		
		public function get constants():Vector.<Constant> 
		{
			return _reflection.constants;
		}
		
		public function get constructorClass():Class 
		{
			return _reflection.constructorClass;
		}
		
		public function get constructorInfo():Constructor 
		{
			return _reflection.constructorInfo;
		}
		
		public function get describeType():Object 
		{
			return _reflection.describeType;
		}
		
		public function get domain():ApplicationDomain 
		{
			return _reflection.domain;
		}
		
		public function get extendsClasses():Vector.<Class> 
		{
			return _reflection.extendsClasses;
		}
		
		public function get fields():Vector.<Field> 
		{
			return _reflection.fields;
		}
		
		public function getConstants():Vector.<Constant> 
		{
			return _reflection.getConstants();
		}
		
		public function getField(name:String):Field 
		{
			return _reflection.getField(name);
		}
		
		public function getFields():Vector.<Field> 
		{
			return _reflection.getFields();
		}
		
		public function getMember(name:String):Member 
		{
			return _reflection.getMember(name);
		}
		
		public function getMembers(memberType:MemberType = null):Vector.<Member> 
		{
			return _reflection.getMembers(memberType);
		}
		
		public function getMetaData(name:String = null):Vector.<MetaData> 
		{
			return _reflection.getMetaData(name);
		}
		
		public function getMethod(name:String):Method 
		{
			return _reflection.getMethod(name);
		}
		
		public function getMethods():Vector.<Method> 
		{
			return _reflection.getMethods();
		}
		
		public function getParameters():Vector.<Parameter> 
		{
			return _reflection.getParameters();
		}
		
		public function getProperties(access:Access = null):Vector.<Property> 
		{
			return _reflection.getProperties(access);
		}
		
		public function getProperty(name:String):Property 
		{
			return _reflection.getProperty(name);
		}
		
		public function get interfaces():Vector.<Class> 
		{
			return _reflection.interfaces;
		}
		
		public function get isArray():Boolean 
		{
			return _reflection.isArray;
		}
		
		public function get isClass():Boolean 
		{
			return _reflection.isClass;
		}
		
		public function get isDate():Boolean 
		{
			return _reflection.isDate;
		}
		
		public function get isDictionary():Boolean 
		{
			return _reflection.isDictionary;
		}
		
		public function get isDynamic():Boolean 
		{
			return _reflection.isDynamic;
		}
		
		public function get isProxy():Boolean
		{
			return _reflection.isProxy;
		}
		
		public function get isEnumeration():Boolean 
		{
			return _reflection.isEnumeration;
		}
		
		public function isExtended(type:Class):Boolean 
		{
			return _reflection.isExtended(type);
		}
		
		public function isExtendedClass(type:Class):Boolean 
		{
			return _reflection.isExtendedClass(type);
		}
		
		public function get isFactory():Boolean 
		{
			return _reflection.isFactory;
		}
		
		public function get isFinal():Boolean 
		{
			return _reflection.isFinal;
		}
		
		public function get isFunction():Boolean 
		{
			return _reflection.isFunction;
		}
		
		public function isImplementedInterface(type:Class):Boolean 
		{
			return _reflection.isImplementedInterface(type);
		}
		
		public function get isNull():Boolean 
		{
			return _reflection.isNull;
		}
		
		public function get isPrimitive():Boolean 
		{
			return _reflection.isPrimitive;
		}
		
		public function get isStatic():Boolean 
		{
			return _reflection.isStatic;
		}
		
		public function isSubclassOf(type:Class):Boolean 
		{
			return _reflection.isSubclassOf(type);
		}
        
        public function isInstanceOf(type:Class):Boolean 
        {
            return _reflection.isInstanceOf(type);
        }
		
		public function get isUndefined():Boolean 
		{
			return _reflection.isUndefined;
		}
		
		public function get isVector():Boolean 
		{
			return _reflection.isVector;
		}
		
		public function get isXML():Boolean 
		{
			return _reflection.isXML;
		}
		
		public function get isXMLList():Boolean 
		{
			return _reflection.isXMLList;
		}
		
		public function get members():Vector.<Member> 
		{
			return _reflection.members;
		}
		
		public function get metaData():Vector.<MetaData> 
		{
			return _reflection.metaData;
		}
		
		public function get methods():Vector.<Method> 
		{
			return _reflection.methods;
		}
		
		public function get name():String 
		{
			return _reflection.name;
		}
		
		public function get packageName():String 
		{
			return _reflection.packageName;
		}
		
		public function get parameters():Vector.<Parameter> 
		{
			return _reflection.parameters;
		}
		
		public function get properties():Vector.<Property> 
		{
			return _reflection.properties;
		}
		
		public function get qualifiedClassName():String 
		{
			return _reflection.qualifiedClassName;
		}
		
		public function get type():Class 
		{
			return _reflection.type;
		}
	}
}