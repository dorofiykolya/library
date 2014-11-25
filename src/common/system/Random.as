package common.system
{
    import flash.utils.getTimer;
    
    /**
     * ...
     * @author dorofiy.com
     */
    public class Random extends TypeObject
    {
        private static const MBIG:int = int.MAX_VALUE;
        private static const MSEED:int = 161803398;
        private static const MZ:int = 0;
        
        private var inext:int;
        private var inextp:int;
        private var seedArray:Vector.<int> = new Vector.<int>(56);
        
        /**
         * constructor
         * @param seed - int value
         */
        public function Random(seed:Number = NaN)
        {
            if (seed != seed)
            {
                seed = getTimer();
            }
            
            var i:int;
            var ii:int;
            var mj:int;
            var mk:int;
            
            //Initialize our Seed array.
            //This algorithm comes from Numerical Recipes in C (2nd Ed.)
            var subtraction:int = (seed == int.MIN_VALUE) ? int.MAX_VALUE : Math.abs(seed);
            mj = MSEED - subtraction;
            seedArray[55] = mj;
            mk = 1;
            for (i = 1; i < 55; i++)
            { //Apparently the range [1..55] is special (Knuth) and so we're wasting the 0'th position.
                ii = (21 * i) % 55;
                seedArray[ii] = mk;
                mk = mj - mk;
                if (mk < 0)
                    mk += MBIG;
                mj = seedArray[ii];
            }
            for (var k:int = 1; k < 5; k++)
            {
                for (i = 1; i < 56; i++)
                {
                    seedArray[i] -= seedArray[1 + (i + 30) % 55];
                    if (seedArray[i] < 0)
                        seedArray[i] += MBIG;
                }
            }
            inext = 0;
            inextp = 21;
            seed = 1;
        }
        
        /**
         * [0..1]
         * @return [0..1]
         */
        public function next():Number
        {
            return sample();
        }
        
        /**
         *
         * @return [0..1]
         */
        [Inline]
        protected final function sample():Number
        {
            return (internalSample() * (1.0 / MBIG));
        }
        
        /**
         *
         * @return [0..int.MAX_VALUE]
         */
        [Inline]
        protected final function sampleInt():int
        {
            return internalSample();
        }
        
        /**
         *
         * @return [0 .. 2 * int.MAX_VALUE - 1]
         */
        [Inline]
        protected final function sampleLarge():Number
        {
            return getSampleForLargeRange();
        }
        
        private final function internalSample():int
        {
            var retVal:int;
            var locINext:int = inext;
            var locINextp:int = inextp;
            
            if (++locINext >= 56)
                locINext = 1;
            if (++locINextp >= 56)
                locINextp = 1;
            
            retVal = seedArray[locINext] - seedArray[locINextp];
            
            if (retVal == MBIG)
                retVal--;
            if (retVal < 0)
                retVal += MBIG;
            
            seedArray[locINext] = retVal;
            
            inext = locINext;
            inextp = locINextp;
            
            return retVal;
        }
        
        private final function getSampleForLargeRange():Number
        {
            // The distribution of double value returned by Sample 
            // is not distributed well enough for a large range.
            // If we use Sample for a range [Int32.MinValue..Int32.MaxValue)
            // We will end up getting even numbers only.
            
            var result:int = internalSample();
            // Note we can't use addition here. The distribution will be bad if we do that.
            var negative:Boolean = (internalSample() % 2 == 0); // decide the sign based on second sample
            if (negative)
            {
                result = -result;
            }
            var d:Number = result;
            d += (int.MAX_VALUE - 1); // get a number in range [0 .. 2 * Int32MaxValue - 1)
            d /= (2 * uint(int.MAX_VALUE)) - 1;
            return d;
        }
    
    }

}