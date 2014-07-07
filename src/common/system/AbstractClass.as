package common.system
{
	import common.system.errors.AbstractClassError;
	
	/**
	 * ...
	 * @author dorofiy.com
	 */
	[ExcludeClass]
	
	public class AbstractClass extends TypeObject
	{
		public function AbstractClass()
		{
			if (ClassType.getClass(this) === AbstractClass)
			{
				throw new AbstractClassError('AbstractClassError: ' + ClassType.getQualifiedClassName(this) + ' class cannot be instantiated.');
			}
		}
	}
}