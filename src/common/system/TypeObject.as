package common.system
{
	/**
	 * ...
	 * @author dorofiy.com
	 */
	public dynamic class TypeObject extends Object implements ITypeObject
	{
        private var _toString:String;
        
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
			return _toString || (_toString = "[" + String(ClassType.getClass(this)).replace(/(\[class |\])/g, "") + " (" + ClassType.getQualifiedClassName(this) + ")]");
		}
	}
}