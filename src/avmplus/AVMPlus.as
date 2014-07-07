package avmplus
{
	
	/**
	 * ...
	 * @author dorofiy.com
	 */
	
	public class AVMPlus
	{
		//--------------------------------------------------------------------------
		//     
		//	PUBLIC CONSTANTS STATIC
		//     
		//--------------------------------------------------------------------------
		
		public static const AVAILABLE:Boolean = describeTypeJSON != null;
		
		public static const FLAG_HIDE_NSURI_METHODS:uint = HIDE_NSURI_METHODS;
		public static const FLAG_HIDE_OBJECT:uint = HIDE_OBJECT;
		public static const FLAG_INCLUDE_ACCESSORS:uint = INCLUDE_ACCESSORS;
		public static const FLAG_INCLUDE_BASES:uint = INCLUDE_BASES;
		public static const FLAG_INCLUDE_CONSTRUCTOR:uint = INCLUDE_CONSTRUCTOR;
		public static const FLAG_INCLUDE_INTERFACES:uint = INCLUDE_INTERFACES;
		public static const FLAG_INCLUDE_METADATA:uint = INCLUDE_METADATA;
		public static const FLAG_INCLUDE_METHODS:uint = INCLUDE_METHODS;
		public static const FLAG_INCLUDE_TRAITS:uint = INCLUDE_TRAITS;
		public static const FLAG_INCLUDE_VARIABLES:uint = INCLUDE_VARIABLES;
		public static const FLAG_USE_ITRAITS:uint = USE_ITRAITS;
		public static const FLAG_FLASH10_FLAGS:uint = FLASH10_FLAGS;
		
		//--------------------------------------------------------------------------
		//     
		//	PUBLIC CONSTANTS STATIC
		//     
		//--------------------------------------------------------------------------
		
		public static const INSTANCE_FLAGS:uint = INCLUDE_BASES | INCLUDE_INTERFACES | INCLUDE_VARIABLES | INCLUDE_ACCESSORS | INCLUDE_METHODS | INCLUDE_METADATA | INCLUDE_CONSTRUCTOR | INCLUDE_TRAITS | USE_ITRAITS | HIDE_OBJECT;
		public static const CLASS_FLAGS:uint = INCLUDE_INTERFACES | INCLUDE_VARIABLES | INCLUDE_ACCESSORS | INCLUDE_METHODS | INCLUDE_METADATA | INCLUDE_TRAITS | HIDE_OBJECT;
		
		//----------------------------------
		//	CONSTRUCTOR
		//----------------------------------
		
		public function AVMPlus()
		{
		
		}
		
		//--------------------------------------------------------------------------
		//     
		//	PUBLIC METHODS STATIC
		//     
		//--------------------------------------------------------------------------
		
		public static function describeTypeWithFlags(target:*, flags:uint):Object
		{
			return describeTypeJSON(target, flags);
		}
		
		public static function describeType(target:*):Object
		{
			return describeTypeJSON(target, FLASH10_FLAGS);
		}
		
		public static function describeInstance(type:Class):Object
		{
			return describeTypeJSON(type, FLASH10_FLAGS | USE_ITRAITS);
		}
		
		public static function describeClass(type:Class):Object
		{
			return describeTypeJSON(type, FLASH10_FLAGS);
		}
	}
}