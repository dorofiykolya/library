package common.system.errors
{
	import common.system.ClassType;
	import common.system.ITypeObject;
	import common.system.Type;
	
	/**
	 * ...
	 * @author dorofiy.com
	 */
	public class AbstractMethodError extends Error implements ITypeObject
	{
		
		public function AbstractMethodError(message:* = "Method needs to be implemented in subclass", id:* = 0)
		{
			super(message, id);
		}
		
		/* INTERFACE common.system.ITypeObject */
		
		public function getType():Type
		{
			return ClassType.getType(this);
		}
	}
}