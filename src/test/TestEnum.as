package test 
{
	import common.system.Enum;
	
	/**
	 * ...
	 * @author dorofiy.com
	 */
	public class TestEnum extends Enum 
	{
		public static const A:TestEnum = new TestEnum(1);
		public static const B:TestEnum = new TestEnum(2);
		public static const C:TestEnum = new TestEnum(3);
		public static const D:TestEnum = new TestEnum(4);
		
		public function TestEnum(value:Object) 
		{
			super(value);
		}
		
	}

}