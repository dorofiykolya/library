package common.system.collection.sort
{
    
    /**
     * ...
     * @author dorofiy.com
     */
    public class QuickSort
    {
        
        public function QuickSort()
        {
        
        }
        
        public static function sort(enumeration:Object, left:int = 0, right:int = int.MAX_VALUE, property:String = null, reverse:Boolean = false):void
        {
            var length:int = enumeration.length;
            if (length > 1)
            {
                if (right >= length)
                {
                    right = length - 1;
                }
                if (left < 0)
                {
                    left = 0;
                }
                if (left < right)
                {
                    if (property)
                    {
                        sortProperty(enumeration, left, right, property, reverse);
                    }
                    else
                    {
                        sortValue(enumeration, left, right, reverse);
                    }
                }
            }
        }
        
        private static function sortValue(enumeration:Object, left:int, right:int, reverse:Boolean):void
        {
            var i:int = left;
            var j:int = right;
            var x:* = enumeration[int((left + right) >> 1)];
            do
            {
                if (reverse)
                {
                    while (enumeration[i] > x)
                        i++;
                    while (enumeration[j] < x)
                        j--;
                }
                else
                {
                    while (enumeration[i] < x)
                        i++;
                    while (enumeration[j] > x)
                        j--;
                }
                
                if (i <= j)
                {
                    var temp:* = enumeration[i];
                    enumeration[i] = enumeration[j];
                    enumeration[j] = temp;
                    i++;
                    j--;
                }
            } while (i < j);
            if (left < j)
                sortValue(enumeration, left, j, reverse);
            if (i < right)
                sortValue(enumeration, i, right, reverse);
        }
        
        private static function sortProperty(enumeration:Object, left:int, right:int, property:String, reverse:Boolean):void
        {
            var i:int = left;
            var j:int = right;
            var x:* = enumeration[left + right >> 1][property];
            do
            {
                if (reverse)
                {
                    while (enumeration[i][property] > x)
                    {
                        ++i;
                    }
                    while (enumeration[j][property] < x)
                    {
                        --j;
                    }
                    
                }
                else
                {
                    while (enumeration[i][property] < x)
                    {
                        ++i;
                    }
                    while (enumeration[j][property] > x)
                    {
                        --j;
                    }
                }
                
                if (i <= j)
                {
                    var temp:* = enumeration[i];
                    enumeration[i] = enumeration[j];
                    enumeration[j] = temp;
                    i++;
                    j--;
                }
            } while (i < j);
            
            if (left < j)
            {
                sortProperty(enumeration, left, j, property, reverse);
            }
            if (i < right)
            {
                sortProperty(enumeration, i, right, property, reverse);
            }
        }
    
    }

}