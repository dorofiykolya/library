package common.system.reflection
{
	
	/**
	 * ...
	 * @author dorofiy.com
	 */
	public class Property extends Member
	{
		internal var _access:Access;
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
			return _declaredBy;
		}
	}
}