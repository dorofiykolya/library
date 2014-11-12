package common.injection.description
{
    import common.injection.providers.IProvider;
    import common.system.IDisposable;
    import common.system.TypeObject;
    
    /**
     * ...
     * @author dorofiy.com
     */
    public class TypeInfo extends TypeObject implements IDisposable
    {
        public var type:Class;
        public var name:String;
        public var id:String;
        
        public function TypeInfo(type:Class, name:String, id:String)
        {
            this.type = type;
            this.name = name;
            this.id = id;
        }
        
        /* INTERFACE common.system.IDisposable */
        
        public function dispose():void
        {
            type = null;
            name = null;
            id = null;
        }
    }
}