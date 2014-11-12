package common.injection {
    import common.injection.maps.IMapping;
    import common.injection.providers.IProvider;
    
    /**
     * ...
     * @author dorofiy.com
     */
    public interface IInjector
    {
        function inject(value:Object):void;
        function map(type:Class, name:String = null):IMapping;
        function unmap(type:Class, name:String = null):void;
        function get parent():IInjector;
        function getObject(type:Class, name:String = null):Object;
        function getProvider(type:Class, name:String = null):IProvider;
    }
}