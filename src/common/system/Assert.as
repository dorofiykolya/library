package common.system
{
	import common.system.errors.IllegalArgumentError;
	import common.system.text.StringUtil;
	
	/**
	 * ...
	 * @author dorofiy.com
	 */
	public class Assert extends TypeObject
	{
		
		public function Assert()
		{
		
		}
		
		/**
		 *
		 * @param	expression
		 * @param	message
		 */
		public static function isTrue(expression:Boolean, message:String = ""):void
		{
			if (!expression)
			{
				if (message == null || message.length == 0)
				{
					message = "[" + ClassType.getQualifiedClassName(Assert) + "][isTrue] - this expression must be true";
				}
				throw new IllegalArgumentError(message);
			}
		}
		
		/**
		 *
		 * @param	instance
		 * @param	abstractClass
		 * @param	message
		 */
		public static function notAbstract(instance:Object, abstractClass:Class, message:String = ""):void
		{
			var instanceName:Class = ClassType.getClass(instance);
			var abstractName:Class = ClassType.getClass(abstractClass);
			
			if (instanceName == abstractName)
			{
				if (message == null || message.length == 0)
				{
					message = "[" + ClassType.getQualifiedClassName(Assert) + "][notAbstract] - instance is an instance of an abstract class";
				}
				throw new IllegalArgumentError(message);
			}
		}
		
		/**
		 *
		 * @param	object
		 * @param	message
		 */
		public static function notNull(object:Object, message:String = ""):void
		{
			if (object == null)
			{
				if (message == null || message.length == 0)
				{
					message = "[" + ClassType.getQualifiedClassName(Assert) + "][notNull] - this argument is required; it must not null";
				}
				throw new IllegalArgumentError(message);
			}
		}
		
		/**
		 *
		 * @param	object
		 * @param	type
		 * @param	message
		 */
		public static function instanceOf(object:Object, type:Class, message:String = ""):void
		{
			if (!(object is type))
			{
				if (message == null || message.length == 0)
				{
					message = "[" + ClassType.getQualifiedClassName(Assert) + "][instanceOf] - this argument is not of type \"" + type + "\"";
				}
				throw new IllegalArgumentError(message);
			}
		}
		
		/**
		 * 
		 * @param	type
		 * @param	parentType
		 * @param	message
		 */
		public static function equalsClassOrSubclassOf(type:Class, parentType:Class, message:String = ""):void
		{
			if (!(type == parentType && ClassType.getInstanceType(type).isExtendedClass(parentType)))
			{
				if (message == null || message.length == 0)
				{
					message = "[" + ClassType.getQualifiedClassName(Assert) + "][subclassOf] - this argument is not a subclass of \"" + parentType + "\"";
				}
				throw new IllegalArgumentError(message);
			}
		}
		
		/**
		 *
		 * @param	type
		 * @param	parentType
		 * @param	message
		 */
		public static function subclassOf(type:Class, parentType:Class, message:String = ""):void
		{
			if (!ClassType.getInstanceType(type).isExtendedClass(parentType))
			{
				if (message == null || message.length == 0)
				{
					message = "[" + ClassType.getQualifiedClassName(Assert) + "][subclassOf] - this argument is not a subclass of \"" + parentType + "\"";
				}
				throw new IllegalArgumentError(message);
			}
		}
		
		/**
		 *
		 * @param	object
		 * @param	interfaceType
		 * @param	message
		 */
		public static function implementationOf(object:*, interfaceType:Class, message:String = ""):void
		{
			if (!ClassType.getInstanceType(object).isImplementedInterface(interfaceType))
			{
				if (message == null || message.length == 0)
				{
					message = "[" + ClassType.getQualifiedClassName(Assert) + "][implementationOf] - this argument does not implement the interface \"" + interfaceType + "\"";
				}
				throw new IllegalArgumentError(message);
			}
		}
		
		/**
		 *
		 * @param	string
		 * @param	message
		 */
		public static function hasText(string:String, message:String = ""):void
		{
			if (StringUtil.isEmpty(string, true))
			{
				if (message == null || message.length == 0)
				{
					message = "[" + ClassType.getQualifiedClassName(Assert) + "][hasText] - this String argument must have text; it must not be <code>null</code>, empty, or blank";
				}
				throw new IllegalArgumentError(message);
			}
		}
		
		/**
		 *
		 * @param	colletion (Array, Vector)
		 * @param	item
		 * @param	message
		 */
		public static function collectionContains(colletion:Object, item:*, message:String = ""):void
		{
			if (colletion.indexOf(item) == -1)
			{
				if (message == null || message.length == 0)
				{
					message = "[" + ClassType.getQualifiedClassName(Assert) + "][collectionContains] - this collection argument does not contain the item \"" + item + "\"";
				}
				throw new IllegalArgumentError(message);
			}
		}
		
		public static function containsKey(object:Object, key:*, message:String = ""):void
		{
			if (!(key in object))
			{
				if (message == null || message.length == 0)
				{
					message = "[" + ClassType.getQualifiedClassName(Assert) + "][containsKey] - this object argument does not contain the key \"" + key + "\"";
				}
				throw new IllegalArgumentError(message);
			}
		}
	}
}