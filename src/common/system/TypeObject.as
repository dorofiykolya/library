package common.system
{
	/**
	 * ...
	 * @author dorofiy.com
	 */
	public dynamic class TypeObject extends Object implements ITypeObject
	{
		//----------------------------------
		//	CONSTRUCTOR
		//----------------------------------
		
		public function TypeObject()
		{
		
		}
		
		//--------------------------------------------------------------------------
		//     
		//	PUBLIC METHODS 
		//     
		//--------------------------------------------------------------------------
		
		public function getType():Type
		{
			return ClassType.getType(this);
		}
		
		public function toString():String
		{
			return "[" + String(ClassType.getClass(this)).replace(/(\[class |\])/g, "") + " (" + ClassType.getQualifiedClassName(this) + ")]";
		}
	}
}