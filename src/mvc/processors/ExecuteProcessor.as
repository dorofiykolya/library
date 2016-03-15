package mvc.processors
{
    import common.context.links.Link;
    import common.context.IContext;
	import common.context.processors.IProcessor;
    import mvc.interfaces.IExecutable;
    import common.system.TypeObject;
    
    /**
     * ...
     * @author dorofiy.com
     */
    public class ExecuteProcessor extends TypeObject implements IProcessor
    {
        [Inject]
        public var context:IContext;
        
        public function ExecuteProcessor()
        {
            super();
        }
        
        /* INTERFACE com.okapp.mvc.processor.IProcessor */
        
        public function process(bean:Link):void
        {
            var executable:IExecutable = bean.instance as IExecutable;
            if (executable)
            {
                executable.execute(context);
            }
        }
        
        /* INTERFACE com.okapp.mvc.processors.IProcessor */
        
        public function setup(bean:Link):void
        {
        
        }
    }
}