package common.system.reflection
{
	
	/**
	 * ...
	 * @author dorofiy.com
	 */
	public class Method extends Member
	{
		internal var _returnType:Class;
		internal var _parameters:Vector.<Parameter>;
		internal var _declaredBy:Class;
		
		public function Method()
		{
			_memberType = MemberType.METHOD;
		}
		
		internal function get requiredParameterCount():int
		{
			var result:int = 0;
			if (_parameters)
			{
				for each (var item:Parameter in _parameters)
				{
					if (item._optional == false)
					{
						result++;
					}
				}
			}
			return result;
		}
		
		public function get returnType():Class
		{
			return _returnType;
		}
		
		public function get parameters():Vector.<Parameter>
		{
			return _parameters.slice();
		}
		
		public function get declaredBy():Class
		{
			return _declaredBy;
		}
	}
}