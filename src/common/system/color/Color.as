package common.system.color
{
	import common.system.TypeObject;
	
	/**
	 * ...
	 * @author dorofiy.com
	 */
	public class Color extends TypeObject
	{
		//--------------------------------------------------------------------------
		//     
		//	PRIVATE VARIABLES 
		//     
		//--------------------------------------------------------------------------
		
		private var _color:uint;
		
		//----------------------------------
		//	CONSTRUCTOR
		//----------------------------------
		
		public function Color(color:uint = 0)
		{
			_color = color;
		}
		
		//--------------------------------------------------------------------------
		//     
		//	PUBLIC PROPERTIES 
		//     
		//--------------------------------------------------------------------------
		
		/**
		 * color
		 */
		public function get color():uint
		{
			return 0;
		}
		
		//--------------------------------------------------------------------------
		//     
		//	PUBLIC METHODS 
		//     
		//--------------------------------------------------------------------------
		
		override public function toString():String
		{
			return _color.toString(16);
		}
		
		//----------------------------------
		//	STATIC
		//----------------------------------
		
		//--------------------------------------------------------------------------
		//     
		//	PUBLIC METHODS 
		//     
		//--------------------------------------------------------------------------
		
		public static function rgb(color:uint):uint
		{
			return (color & 0xffffff);
		}
		
		public static function alpha(color:uint):uint
		{
			return (color >> 24) & 0xFF;
		}
		
		public static function red(color:uint):uint
		{
			return (color >> 16) & 0xFF;
		}
		
		public static function green(color:uint):uint
		{
			return (color >> 8) & 0xFF;
		}
		
		public static function blue(color:uint):uint
		{
			return color & 0xFF;
		}
		
		public static function rgbaToHex(red:int, green:int, blue:int, alpha:int):uint
		{
			return alpha << 24 ^ red << 16 ^ green << 8 ^ blue;
		}
		
		public static function rgbToHex(red:int, green:int, blue:int):uint
		{
			return red << 16 ^ green << 8 ^ blue;
		}
		
		public static function hexToRgba(color:uint):Rgba
		{
			var result:Rgba = new Rgba();
			
			result.alpha = (color >> 24) & 0xFF;
			result.red = (color >> 16) & 0xFF;
			result.green = (color >> 8) & 0xFF;
			result.blue = color & 0xFF;
			
			return result;
		}
		
		public static function hexToRgb(color:uint):Rgb
		{
			var result:Rgb = new Rgb;
			
			result.red = (color >> 16) & 0xFF;
			result.green = (color >> 8) & 0xFF;
			result.blue = color & 0xFF;
			
			return result;
		}
		
		public static function hexToVector(color:uint):Vector.<uint>
		{
			return new <uint>[(color >> 16) & 0xFF, (color >> 8) & 0xFF, (color & 0xFF)];
		}
		
		public static function interpolateColorsRgb(color1:uint, color2:uint, amount:Number):uint
		{
			var red:uint = Color.red(color1) * (1 - amount) + Color.red(color2) * amount;
			var green:uint = Color.green(color1) * (1 - amount) + Color.green(color2) * amount;
			var blue:uint = Color.blue(color1) * (1 - amount) + Color.blue(color2) * amount;
			
			return rgbToHex(red, green, blue);
		}
		
		public static function interpolateColorsRgba(color1:uint, color2:uint, amount:Number):uint
		{
			var red:uint = Color.red(color1) * (1 - amount) + Color.red(color2) * amount;
			var green:uint = Color.green(color1) * (1 - amount) + Color.green(color2) * amount;
			var blue:uint = Color.blue(color1) * (1 - amount) + Color.blue(color2) * amount;
			var alpha:uint = 255;
			
			return rgbaToHex(red, green, blue, alpha);
		}
		
		public static function invert(color:uint):uint
		{
			return 0xFFFFFF - color;
		}
	}
}