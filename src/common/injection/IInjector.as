package common.injection {
    import common.injection.maps.IMapping;
    
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
    }
}