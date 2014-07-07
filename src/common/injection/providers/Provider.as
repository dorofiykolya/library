package common.injection.providers
{
	import common.injection.Injector;
	import common.system.ClassType;
	import common.system.errors.AbstractClassError;
	import common.system.errors.AbstractMethodError;
	import common.system.TypeObject;
	
	/**
	 * ...
	 * @author dorofiy.com
	 */
	public class Provider extends TypeObject implements IProvider
	{
		protected var _value:Object;
		protected var _type:Class;
		
		public function Provider(type:Class, value:Object)
		{
			_type = type;
			_value = value;
			
			if (Object(this).constructor === Provider)
			{
				throw new AbstractClassError('AbstractClassError: ' + ClassType.getQualifiedClassName(this) + ' class cannot be instantiated.');
			}
		}
		
		/* INTERFACE common.injection.depends.IDependency */
		
		public function apply(injector:Injector, type:Class):Object
		{
			throw new AbstractMethodError("Method needs to be implemented in subclass");
		}
		
		/* INTERFACE common.injection.providers.IProvider */
		
		public function dispose():void 
		{
			_value = null;
			_type = null;
		}
	}
}