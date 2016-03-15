package mvc.configurations
{
    import common.context.IContext;
    
    /**
     * ...
     * @author dorofiy.com
     */
    public interface IConfigurable
    {
        function config(context:IContext):void;
    }
}