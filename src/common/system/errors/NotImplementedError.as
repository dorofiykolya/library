package common.system.errors
{
	import common.system.ClassType;
	import common.system.ITypeObject;
	import common.system.Type;
	
	/**
	 * ...
	 * @author dorofiy.com
	 */
	public class NotImplementedError extends Error implements ITypeObject
	{
		
		public function NotImplementedError(message:* = "", id:* = 0)
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