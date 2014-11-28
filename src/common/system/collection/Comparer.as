package common.system.collection
{
    import common.system.IComparable;
    import common.system.TypeObject;
    
    /**
     * ...
     * @author dorofiy.com
     */
    public class Comparer extends TypeObject implements IComparer
    {
        
        public function Comparer()
        {
            super();
        
        }
        
        /* INTERFACE common.system.collection.IComparer */
        
        public function compare(a:Object, b:Object):int
        {
            if (a == b)
                return 0;
            if (a == null)
                return -1;
            if (b == null)
                return 1;
            
            var ia:IComparable = a as IComparable;
            if (ia != null)
                return ia.compareTo(b);
            
            var ib:IComparable = b as IComparable;
            if (ib != null)
                return -ib.compareTo(a);
                
            throw new ArgumentError("Argument not implement IComparable");
        }
    
    }

}