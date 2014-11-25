package common.system 
{
	/**
     * ...
     * @author dorofiy.com
     */
    public class NumberRandom extends Random 
    {
        
        public function NumberRandom(seed:Number=NaN) 
        {
            super(seed);
        }
        
        /**
         * An int [0..1]
         * @return An int [0..1]
         */
        public override function next():Number
        {
            return sample();
        }
        
        /**
         * An int [minvalue..maxvalue]
         * @param minValue
         * @param maxValue
         * @return An int [minvalue..maxvalue]
         */
        public function nextInRange(minValue:Number, maxValue:Number):Number
        {
            if (minValue > maxValue)
            {
                throw new ArgumentError("minValue > maxValue");
            }
            
            var range:Number = maxValue - minValue;
            if (range <= int.MAX_VALUE)
            {
                return (sample() * range) + minValue;
            }
            else
            {
                return Number(sampleLarge() * range) + minValue;
            }
        }
        
        /**
         * An int [0..maxValue]
         * @param maxValue
         * @return An int [0..maxValue]
         */
        public function nextInMax(maxValue:Number):Number
        {
            if (maxValue < 0)
            {
                throw new ArgumentError("maxValue < 0");
            }
            return sample() * maxValue;
        }
        
    }

}