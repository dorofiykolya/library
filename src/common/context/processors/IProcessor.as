package common.context.processors
{
    import common.context.links.Link;
    import common.context.IContext;
    
    public interface IProcessor
    {
        function setup(bean:Link):void;
        function process(bean:Link):void
    }
}
