package mvc.commands
{
    import common.system.Cache;
    import common.system.ClassType;
    
    /**
     * ...
     * @author dorofiy.com
     */
    public class CommandFactory
    {
        private static const TYPE_NAME:String = ClassType.getQualifiedClassName(CommandFactory) + "-pool";
        
        public function CommandFactory()
        {
        
        }
        
        internal static function fromPool(type:Class):ICommand
        {
            var collection:Vector.<ICommand> = Cache.cache.getStorageValue(TYPE_NAME, type);
            if (collection == null || collection.length == 0)
            {
                return new type();
            }
            return collection.pop();
        }
        
        internal static function toPool(value:ICommand):void
        {
            var type:Class = ClassType.getAsClass(value);
            var collection:Vector.<ICommand> = Cache.cache.getStorageValue(TYPE_NAME, type);
            if (collection == null)
            {
                collection = new Vector.<ICommand>();
                Cache.cache.setStorageValue(TYPE_NAME, type, collection);
            }
            collection[collection.length] = value;
        }
    }

}