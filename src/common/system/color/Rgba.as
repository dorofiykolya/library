package common.system.color
{
	import common.system.utils.formatString;
	
	/**
	 * ...
	 * @author dorofiy
	 */
	public class Rgba extends Rgb
	{
		//--------------------------------------------------------------------------
		//     
		//	PUBLIC VARIABLES 
		//     
		//--------------------------------------------------------------------------
		
		public var alpha:uint;
		
		//----------------------------------
		//	CONSTRUCTOR
		//----------------------------------
		
		public function Rgba(red:int = 0, green:int = 0, blue:int = 0, alpha:int = 0)
		{
			this.red = red;
			this.green = green;
			this.blue = blue;
			this.alpha = alpha;
		}
		
		override public function get color():uint
		{
			return alpha << 24 ^ red << 16 ^ green << 8 ^ blue;
		}
		
		override public function toString():String
		{
			return formatString("[rgba(red:{0}, green:{1}, blue:{2}, alpha:{3})]", red.toString(16), green.toString(16), blue.toString(16), alpha.toString(16));
		}
	}
}