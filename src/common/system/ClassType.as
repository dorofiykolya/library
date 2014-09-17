package common.system
{
	import flash.system.ApplicationDomain;
	import flash.utils.getDefinitionByName;
	import flash.utils.getQualifiedClassName;
	import flash.utils.getQualifiedSuperclassName;
	import flash.utils.Proxy;
	
	/**
	 * ...
	 * @author dorofiy.com
	 */
	public class ClassType extends TypeObject
	{
		private static const VECTOR:String = "__AS3__.vec::Vector.";
		
		public function ClassType()
		{
		
		}
		
		public static function getClassType(value:Object, domain:ApplicationDomain = null):Type
		{
			return Type.getType(value, domain).classType;
		}
		
		public static function getInstanceType(value:Object, domain:ApplicationDomain = null):Type
		{
			return Type.getType(value, domain).instanceType;
		}
		
		public static function isSubclassOf(subclass:Object, superclass:Class):Boolean
		{
			return getInstanceType(subclass).isSubclassOf(superclass);
		}
		
		public static function getType(value:Object, domain:ApplicationDomain = null):Type
		{
			return Type.getType(value, domain);
		}
		
		public static function getDefinition(name:String, domain:ApplicationDomain = null):Object
		{
			if (name == null)
			{
				return null;
			}
			domain ||= ApplicationDomain.currentDomain;
			
			var result:Object;
			while (!domain.hasDefinition(name))
			{
				if (domain.parentDomain)
				{
					domain = domain.parentDomain;
				}
				else
				{
					break;
				}
			}
			if (domain.hasDefinition(name))
			{
				result = domain.getDefinition(name) as Class;
			}
			return result;
		}
		
		public static function getClassByName(className:String, domain:ApplicationDomain = null):Class
		{
			if (className == null)
			{
				return null;
			}
			domain ||= ApplicationDomain.currentDomain;
			
			var result:Class;
			while (!domain.hasDefinition(className))
			{
				if (domain.parentDomain)
				{
					domain = domain.parentDomain;
				}
				else
				{
					break;
				}
			}
			if (domain.hasDefinition(className))
			{
				result = domain.getDefinition(className) as Class;
			}
			return result;
		}
		
		public static function getTypeByClassName(className:String, domain:ApplicationDomain = null):Type
		{
			return getType(getClassByName(className, domain));
		}
		
		public static function getClassTypeByClassName(className:String, domain:ApplicationDomain = null):Type
		{
			return getType(getClassByName(className, domain)).classType;
		}
		
		public static function getInstanceTypeByClassName(className:String, domain:ApplicationDomain = null):Type
		{
			return getType(getClassByName(className, domain)).instanceType;
		}
		
		public static function isPrivateClass(object:*):Boolean
		{
			if (object == null)
			{
				return false;
			}
			var className:String = ClassType.getQualifiedClassName(object);
			var index:int = className.indexOf("::");
			var inRootPackage:Boolean = (index == -1);
			if (inRootPackage)
			{
				return false;
			}
			var ns:String = className.substr(0, index);
			return (ns === "" || ns.indexOf(".as$") > -1);
		}
		
		public static function getAsClass(value:Object):Class
		{
			if (value is Class)
			{
				return Class(value);
			}
			return getClass(value);
		}
		
		public static function getClass(value:Object):Class
		{
			if (value == null)
			{
				return null;
			}
			if (!(value is Proxy))
			{
				var constructor:Class = value.constructor as Class;
				if (constructor && value is constructor)
				{
					if (constructor == Number)
					{
						if (value is int)
							return int;
						if (value is uint)
							return uint;
						return Number;
					}
					return constructor;
				}
			}
			return Class(ClassType.getDefinitionByName(ClassType.getQualifiedClassName(value)));
		}
		
		public static function newInstance(type:Class, ... args):Object
		{
			return getInstanceType(type).newInstance.apply(null, args);
		}
		
		public static function getQualifiedClassName(value:*):String
		{
			return flash.utils.getQualifiedClassName(value);
		}
		
		public static function getQualifiedSuperclassName(value:*):String
		{
			return flash.utils.getQualifiedSuperclassName(value);
		}
		
		public static function getDefinitionByName(name:String):Object
		{
			return flash.utils.getDefinitionByName(name);
		}
		
		public static function isVector(value:Object):Boolean
		{
			var cls:String = flash.utils.getQualifiedClassName(value);
			if (cls.indexOf(VECTOR) == 0)
			{
				return true;
			}
			return false;
		}
		
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
	}
}