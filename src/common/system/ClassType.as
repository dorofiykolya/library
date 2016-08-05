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
        
        /**
         * 
         * @param value
         * @param domain
         * @return
         */
        public static function getClassType(value:Object, domain:ApplicationDomain = null):Type
        {
            return Type.getType(value, domain).classType;
        }
        
        /**
         * 
         * @param value
         * @param domain
         * @return
         */
        public static function getInstanceType(value:Object, domain:ApplicationDomain = null):Type
        {
            return Type.getType(value, domain).instanceType;
        }
        
        /**
         * 
         * @param subclass
         * @param superclass
         * @return
         */
        public static function isSubclassOf(subclass:Object, superclass:Class):Boolean
        {
            return getInstanceType(subclass).isSubclassOf(superclass);
        }
        
        /**
         * 
         * @param value
         * @param domain
         * @return
         */
        public static function getType(value:Object, domain:ApplicationDomain = null):Type
        {
            return Type.getType(value, domain);
        }
        
        /**
         * 
         * @param name
         * @param domain
         * @return
         */
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
        
        /**
         * 
         * @param className
         * @param domain
         * @return
         */
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
        
        /**
         * 
         * @param className
         * @param domain
         * @return
         */
        public static function getTypeByClassName(className:String, domain:ApplicationDomain = null):Type
        {
            return getType(getClassByName(className, domain));
        }
        
        /**
         * 
         * @param className
         * @param domain
         * @return
         */
        public static function getClassTypeByClassName(className:String, domain:ApplicationDomain = null):Type
        {
            return getType(getClassByName(className, domain)).classType;
        }
        
        /**
         * 
         * @param className
         * @param domain
         * @return
         */
        public static function getInstanceTypeByClassName(className:String, domain:ApplicationDomain = null):Type
        {
            return getType(getClassByName(className, domain)).instanceType;
        }
        
        /**
         * 
         * @param object
         * @return
         */
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
        
        /**
         * 
         * @param type
         * @return
         */
        public static function isInterface(type:Class):Boolean
        {
            return ClassType.getInstanceType(type).isInterface;
        }
        
        /**
         * 
         * @param value
         * @return
         */
        public static function getAsClass(value:Object):Class
        {
            if (value is Class)
            {
                return Class(value);
            }
            return getClass(value);
        }
        
        /**
         * 
         * @param value
         * @return
         */
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
        
        /**
         * 
         * @param type
         * @param ... args
         * @return
         */
        public static function newInstance(type:Class, ... args):Object
        {
            return getInstanceType(type).newInstance.apply(null, args);
        }
        
        /**
         * 
         * @param type
         * @param args
         * @return
         */
        public static function newInstanceWith(type:Class, args:Array):Object
        {
            return getInstanceType(type).newInstance.apply(null, args);
        }
        
        /**
         * 
         * @param value
         * @return
         */
        public static function getQualifiedClassName(value:*):String
        {
            return flash.utils.getQualifiedClassName(value);
        }
        
        /**
         * 
         * @param value
         * @return
         */
        public static function getQualifiedSuperclassName(value:*):String
        {
            return flash.utils.getQualifiedSuperclassName(value);
        }
        
        /**
         * 
         * @param name
         * @return
         */
        public static function getDefinitionByName(name:String):Object
        {
            return flash.utils.getDefinitionByName(name);
        }
        
        /**
         * 
         * @param value
         * @return
         */
        public static function isVector(value:Object):Boolean
        {
            var cls:String = flash.utils.getQualifiedClassName(value);
            if (cls.indexOf(VECTOR) == 0)
            {
                return true;
            }
            return false;
        }
        
        /**
         * 
         * @param value
         */
        public static function isArray(value:Object):Boolean 
        {
            return value is Array;
        }
        
        /**
         * 
         * @param value
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
		 * cast type, "true" => true 
		 * @param	value
		 * @param	toType
		 * @return	castedType
		 */
		public static function cast(value:Object, toType:Class):Object
		{
			if (value is String)
			{
				if (toType == Boolean)
				{
					if (value == "true") return true;
					return false;
				}
				else if (value == "null") 
				{
					return null;
				}
				else if (toType == Number)
				{
					if (String(value).indexOf(",") != -1)
					{
						value = String(value).replace(",", ".");
					}
					return parseFloat(String(value));
				}
			}
			return toType(value);
		}
    }
}