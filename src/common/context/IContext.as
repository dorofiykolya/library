package common.context
{
    import common.context.links.Link;
    import common.injection.IInjector;
    
    /**
     * ...
     * @author dorofiy.com
     */
    public interface IContext
    {
        function install(... extensions):IContext;
        function getObject(type:Class, name:String = null):Object;
        function get injector():IInjector;
        function get parent():IContext;
    }
}