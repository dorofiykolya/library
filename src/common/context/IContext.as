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
        //function addBean(... beans):IContext;
        function getBean(nameOrType:Object):Link;
        function getBeans(type:Class):Vector.<Link>;
        function getObject(type:Class, name:String = null):Object;
        function get injector():IInjector;
        function get parent():IContext;
    }
}