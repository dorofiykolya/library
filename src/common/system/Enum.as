package common.system
{
	import common.system.errors.AbstractClassError;
	import common.system.reflection.Constant;
	
	/**
	 * ...
	 * @author dorofiy.com
	 */
	public class Enum extends TypeObject implements IEquatable, IComparable
	{
		private var _value:Object;
		
		public function Enum(value:Object)
		{
			if (Object(this).constructor === Enum)
			{
				throw new AbstractClassError('AbstractClassError: ' + ClassType.getQualifiedClassName(this) + ' class cannot be instantiated.');
			}
			_value = value;
		}
		
		/**
		 * parameters array of Enum or value
		 */
		public function any(...enums:Array/** array of (Enum or value) */):Boolean
		{
			for each (var enum:Object in enums) 
			{
				if (equals(enum))
				{
					return true;
				}
			}
			return false;
		}
		
		public function get value():Object
		{
			return _value;
		}
		
		public override function toString():String
		{
			return String(_value);
		}
		
		public static function getEnums(enumClass:Class):Vector.<Enum>
		{
			var result:Vector.<Enum> = Cache.cache.getEnums(enumClass);
			if (result == null)
			{
				var type:Type = Type.getType(enumClass);
				if (type.instanceType.isSubclassOf(Enum) == false)
				{
					throw new ArgumentError("ArgumentError: " + ClassType.getQualifiedClassName(enumClass) + " does not extend: " + ClassType.getQualifiedClassName(Enum));
				}
				
				Cache.cache.setEnumClass(enumClass);
				
				result = new Vector.<Enum>(type.constants.length);
				var current:Enum;
				var index:int;
				for each (var item:Constant in type.constants)
				{
					if (Type.getType(item.type).instanceType.isSubclassOf(Enum))
					{
						current = Enum(enumClass[item.name]);
						Cache.cache.setEnum(enumClass, current._value, current);
						result[index] = current;
						index++;
					}
				}
				result.length = index;
				result.sort(sortEnums);
				Cache.cache.setEnums(enumClass, result);
			}
			return result;
		}
		
		public static function getEnum(enumClass:Class, value:Object):Enum
		{
			var enum:Enum = Cache.cache.getEnum(enumClass, value);
			if (enum == null)
			{
				if (Cache.cache.containsEnumClass(enumClass) == false)
				{
					var type:Type = Type.getType(enumClass);
					if (type.instanceType.isSubclassOf(Enum) == false)
					{
						throw new ArgumentError("ArgumentError: " + ClassType.getQualifiedClassName(enumClass) + " does not extend: " + ClassType.getQualifiedClassName(Enum));
					}
					
					Cache.cache.setEnumClass(enumClass);
					
					var current:Enum;
					for each (var item:Constant in type.constants)
					{
						if (Type.getType(item.type).instanceType.isSubclassOf(Enum))
						{
							current = Enum(enumClass[item.name]);
							Cache.cache.setEnum(enumClass, current._value, current);
							if (current._value == value)
							{
								enum = current;
							}
						}
					}
				}
			}
			return enum;
		}
		
		static private function sortEnums(enum1:Enum, enum2:Enum):int
		{
			return enum1.compareTo(enum2);
		}
		
		/* INTERFACE common.system.IEquatable */
		
		public function equals(value:Object):Boolean
		{
			if (value is Enum)
			{
				return Enum(value)._value === _value;
			}
			return _value === value;
		}
		
		/* INTERFACE common.system.IComparable */
		
		public function compareTo(value:Object):int
		{
			var other:Enum = value as Enum;
			if (other)
			{
				if (_value > other._value)
					return 1;
				if (_value < other._value)
					return -1;
				return 0;
			}
			return 1;
		}
	}
}