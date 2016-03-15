package common.system.reflection
{
	import common.system.ClassType;
	
	/**
	 * ...
	 * @author dorofiy.com
	 */
	public class Method extends Member
	{
		private var  _requiredParams:int;
		
		internal var _returnTypeName:String;
		internal var _returnType:Class;
		internal var _parameters:Vector.<Parameter>;
		internal var _declaredByName:String;
		internal var _declaredBy:Class;
		
		public function Method()
		{
			_requiredParams = -1;
			_memberType = MemberType.METHOD;
		}
		
		internal function get requiredParameterCount():int
		{
			if (_requiredParams != -1) 
			{
				return _requiredParams;
			}
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
			_requiredParams = result;
			return result;
		}
		
		public function get returnType():Class
		{
			if (_returnType != null)
			{
				return _returnType;
			}
			if (_returnTypeName != null)
			{
				_returnType = Class(ClassType.getDefinitionByName(_returnTypeName));
			}
			return _returnType;
		}
		
		public function get parameters():Vector.<Parameter>
		{
			return _parameters.slice();
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