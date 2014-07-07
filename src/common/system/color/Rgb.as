package common.system.color
{
	import common.system.TypeObject;
	import common.system.utils.formatString;
	
	/**
	 * ...
	 * @author dorofiy
	 */
	public class Rgb extends Color
	{
		//--------------------------------------------------------------------------
		//     
		//	PUBLIC VARIABLES 
		//     
		//--------------------------------------------------------------------------
		
		public var red:uint;
		public var green:uint;
		public var blue:uint;
		
		//----------------------------------
		//	CONSTRUCTOR
		//----------------------------------
		
		public function Rgb(red:uint = 0, green:uint = 0, blue:uint = 0)
		{
			this.red = red;
			this.green = green;
			this.blue = blue;
		}
		
		override public function get color():uint
		{
			return red << 16 ^ green << 8 ^ blue;
			;
		}
		
		override public function toString():String
		{
			return formatString("[rgb(red:{0}, green:{1}, blue:{2})]", red.toString(16), green.toString(16), blue.toString(16));
		}
	}
}