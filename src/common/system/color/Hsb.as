package common.system.color
{
	import common.system.TypeObject;
	import common.system.utils.formatString;
	
	public final class Hsb extends Color
	{
		//--------------------------------------------------------------------------
		//     
		//	PRIVATE VARIABLES 
		//     
		//--------------------------------------------------------------------------
		
		private var _brightness:Number;
		private var _saturation:Number;
		private var _hue:Number;
		
		//----------------------------------
		//	CONSTRUCTOR
		//----------------------------------
		
		public function Hsb(hue:Number = NaN, saturation:Number = NaN, brightness:Number = NaN)
		{
			this.hue = hue;
			this.saturation = saturation;
			this.brightness = brightness;
		}
		
		//--------------------------------------------------------------------------
		//     
		//	PUBLIC PROPERTIES 
		//     
		//--------------------------------------------------------------------------
		
		public function get hue():Number
		{
			return _hue;
		}
		
		public function set hue(value:Number):void
		{
			_hue = value % 360;
		}
		
		public function get saturation():Number
		{
			return _saturation;
		}
		
		public function set saturation(value:Number):void
		{
			_saturation = value;
		}
		
		public function get brightness():Number
		{
			return _brightness;
		}
		
		public function set brightness(value:Number):void
		{
			_brightness = value;
		}
		
		//--------------------------------------------------------------------------
		//     
		//	PUBLIC METHODS 
		//     
		//--------------------------------------------------------------------------
		
		override public function get color():uint
		{
			return hsbToRgb(_hue, _saturation, _brightness);
		}
		
		override public function toString():String
		{
			return formatString("[hsb(hue:{0}, saturation:{1}, brightness:{2})]", _hue.toString(16), _saturation.toString(16), _brightness.toString(16));
		}
		
		//----------------------------------
		//	STATIC
		//----------------------------------
		
		//--------------------------------------------------------------------------
		//     
		//	PUBLIC METHODS 
		//     
		//--------------------------------------------------------------------------
		
		public static function hsbToRgb(hue:Number, saturation:Number, brightness:Number):uint
		{
			var r:Number, g:Number, b:Number;
			if (saturation == 0)
			{
				r = g = b = brightness;
			}
			else
			{
				var h:Number = (hue % 360) / 60;
				var i:int = int(h);
				var f:Number = h - i;
				var p:Number = brightness * (1 - saturation);
				var q:Number = brightness * (1 - (saturation * f));
				var t:Number = brightness * (1 - (saturation * (1 - f)));
				switch (i)
				{
					case 0: 
						r = brightness;
						g = t;
						b = p;
						break;
					case 1: 
						r = q;
						g = brightness;
						b = p;
						break;
					case 2: 
						r = p;
						g = brightness;
						b = t;
						break;
					case 3: 
						r = p;
						g = q;
						b = brightness;
						break;
					case 4: 
						r = t;
						g = p;
						b = brightness;
						break;
					case 5: 
						r = brightness;
						g = p;
						b = q;
						break;
				}
			}
			r *= 255;
			g *= 255;
			b *= 255;
			return (r << 16 | g << 8 | b);
		}
		
		static public function rgbToHsb(rgb:uint):Hsb
		{
			var hue:Number, saturation:Number, brightness:Number;
			var r:Number = ((rgb >> 16) & 0xff) / 255;
			var g:Number = ((rgb >> 8) & 0xff) / 255;
			var b:Number = (rgb & 0xff) / 255;
			var max:Number = Math.max(r, Math.max(g, b));
			var min:Number = Math.min(r, Math.min(g, b));
			var delta:Number = max - min;
			brightness = max;
			if (max != 0)
			{
				saturation = delta / max;
			}
			else
			{
				saturation = 0;
			}
			if (saturation == 0)
			{
				hue = NaN;
			}
			else
			{
				if (r == max)
				{
					hue = (g - b) / delta;
				}
				else if (g == max)
				{
					hue = 2 + (b - r) / delta
				}
				else if (b == max)
				{
					hue = 4 + (r - g) / delta;
				}
				hue = hue * 60;
				if (hue < 0)
				{
					hue += 360;
				}
			}
			return new Hsb(hue, saturation, brightness);
		}
	}
}