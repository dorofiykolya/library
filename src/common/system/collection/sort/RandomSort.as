package common.system.collection.sort
{
    
    /**
     * ...
     * @author dorofiy.com
     */
    public class RandomSort
    {
        
        public function RandomSort()
        {
        
        }
        
        public static function sort(enumeration:Object):void
        {
            var n:int = enumeration.length;
            while (n > 1)
            {
                var k:int = int(Math.random() * n);
                n--;
                var temp:Object = enumeration[n];
                enumeration[n] = enumeration[k];
                enumeration[k] = temp;
            }
        }
    }
}