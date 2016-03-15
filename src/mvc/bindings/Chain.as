package mvc.bindings
{
    import common.system.IDisposable;
    
    /**
     * ...
     * @author dorofiy.com
     */
    public class Chain implements IDisposable
    {
        public var from:Object;
        public var fromProperty:String;
        public var to:Object;
        public var toProperty:String;
        
        public function Chain()
        {
        
        }
        
        /* INTERFACE common.system.IDisposable */
        
        public function dispose():void
        {
            from = null;
            fromProperty = null;
            to = null;
            toProperty = null;
        }
    }
}