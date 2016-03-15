package common.context.extensions
{
    import common.context.IContext;
    
    /**
     * ...
     * @author dorofiy.com
     */
    public interface IExtension
    {
        function extend(context:IContext):void;
    }

}