package common.system.reflection
{
	import common.system.ClassType;
	
	/**
	 * ...
	 * @author dorofiy.com
	 */
	public class Property extends Member
	{
		internal var _access:Access;
		internal var _declaredByName:String;
		internal var _declaredBy:Class;
		
		public function Property()
		{
			_memberType = MemberType.PROPERTY;
		}
		
		public function get access():Access
		{
			return _access;
		}
		
		public function get declaredBy():Class
		{
			if (_declaredBy != null)
			{
				return _declaredBy;
			}
			if (_declaredByName != null)
			{
				_declaredBy = Class(ClassType.getDefinitionByName(_declaredByName));
			}
			return _declaredBy;
		}
	}
}