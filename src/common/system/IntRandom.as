package common.system 
{
	/**
     * ...
     * @author dorofiy.com
     */
    public class IntRandom extends Random 
    {
        
        public function IntRandom(seed:Number=NaN) 
        {
            super(seed);
        }
        
        /**
         * An int [0..int.MAX_VALUE]
         * @return An int [0..int.MAX_VALUE]
         */
        public override function next():Number
        {
            return sampleInt();
        }
        
        /**
         * An int [minvalue..maxvalue]
         * @param minValue
         * @param maxValue
         * @return An int [minvalue..maxvalue]
         */
        public function nextInRange(minValue:int, maxValue:int):int
        {
            if (minValue > maxValue)
            {
                throw new ArgumentError("minValue > maxValue");
            }
            
            var range:Number = maxValue - minValue;
            if (range <= int.MAX_VALUE)
            {
                return (int(sample() * range) + minValue);
            }
            else
            {
                return int(Number(sampleLarge() * range) + minValue);
            }
        }
        
        /**
         * An int [0..maxValue]
         * @param maxValue
         * @return An int [0..maxValue]
         */
        public function nextInMax(maxValue:int):int
        {
            if (maxValue < 0)
            {
                throw new ArgumentError("maxValue < 0");
            }
            return int(sample() * maxValue);
        }
        
    }

}