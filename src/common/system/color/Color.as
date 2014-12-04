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
        
        /**
         *  Performs an RGB multiplication of two RGB colors.
         *  <p>This always results in a darker number than either
         *  original color unless one of them is white,
         *  in which case the other color is returned.</p>
         *  @param rgb1 First RGB color.
         *  @param rgb2 Second RGB color.
         *  @return RGB multiplication of the two colors.
         */
        public static function rgbMultiply(rgb1:uint, rgb2:uint):uint
        {
            var r1:Number = (rgb1 >> 16) & 0xFF;
            var g1:Number = (rgb1 >> 8) & 0xFF;
            var b1:Number = rgb1 & 0xFF;
            
            var r2:Number = (rgb2 >> 16) & 0xFF;
            var g2:Number = (rgb2 >> 8) & 0xFF;
            var b2:Number = rgb2 & 0xFF;
            
            return ((r1 * r2 / 255) << 16) | ((g1 * g2 / 255) << 8) | (b1 * b2 / 255);
        }
        
        /**
         *  Performs a linear brightness adjustment of an RGB color.
         *  <p>The same amount is added to the red, green, and blue channels
         *  of an RGB color.
         *  Each color channel is limited to the range 0 through 255.</p>
         *  @param rgb color.
         *  @param brite Amount to be added to each color channel.
         *  The range for this parameter is -255 to 255;
         *  -255 produces black while 255 produces white.
         *  If this parameter is 0, the RGB color returned
         *  is the same as the original color.
         *
         *  @return rgb color.
         */
        public static function rgbLinearBrightness(rgb:uint, brite:Number):uint
        {
            var r:Number = Math.max(Math.min(((rgb >> 16) & 0xFF) + brite, 255), 0);
            var g:Number = Math.max(Math.min(((rgb >> 8) & 0xFF) + brite, 255), 0);
            var b:Number = Math.max(Math.min((rgb & 0xFF) + brite, 255), 0);
            
            return (r << 16) | (g << 8) | b;
        }
        
        /**
         *  Performs a scaled brightness adjustment of an RGB color.
         *  @param rgb color.
         *  @param brite The percentage to brighten or darken the original color.
         *  If positive, the original color is brightened toward white
         *  by this percentage. If negative, it is darkened toward black
         *  by this percentage.
         *  The range for this parameter is -100 to 100;
         *  -100 produces black while 100 produces white.
         *  If this parameter is 0, the RGB color returned
         *  is the same as the original color.
         *
         *  @return rgb color.
         */
        public static function rgbScaleBrightness(rgb:uint, brite:Number):uint
        {
            var r:Number;
            var g:Number;
            var b:Number;
            
            if (brite == 0)
                return rgb;
            
            if (brite < 0)
            {
                brite = (100 + brite) / 100;
                r = ((rgb >> 16) & 0xFF) * brite;
                g = ((rgb >> 8) & 0xFF) * brite;
                b = (rgb & 0xFF) * brite;
            }
            else // bright > 0
            {
                brite /= 100;
                r = ((rgb >> 16) & 0xFF);
                g = ((rgb >> 8) & 0xFF);
                b = (rgb & 0xFF);
                
                r += ((0xFF - r) * brite);
                g += ((0xFF - g) * brite);
                b += ((0xFF - b) * brite);
                
                r = Math.min(r, 255);
                g = Math.min(g, 255);
                b = Math.min(b, 255);
            }
            
            return (r << 16) | (g << 8) | b;
        }
    }
}