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
        public var provider:IProvider;
        public var name:String;
        
        public function TypeInfo(provider:IProvider, type:Class, name:String)
        {
            this.type = type;
            this.provider = provider;
            this.name = name;
        }
        
        /* INTERFACE common.system.IDisposable */
        
        public function dispose():void
        {
            type = null;
            provider = null;
            name = null;
        }
    }
}