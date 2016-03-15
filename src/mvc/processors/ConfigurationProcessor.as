package mvc.processors
{
    import common.context.links.Link;
	import common.context.processors.IProcessor;
    import mvc.configurations.IConfigurable;
    import common.context.IContext;
    import common.system.TypeObject;
    
    /**
     * ...
     * @author dorofiy.com
     */
    public class ConfigurationProcessor extends TypeObject implements IProcessor
    {
        [Inject]
        public var context:IContext;
        
        public function ConfigurationProcessor()
        {
        
        }
        
        /* INTERFACE com.okapp.mvc.processor.IProcessor */
        
        public function process(bean:Link):void
        {
            var configurable:IConfigurable = bean.instance as IConfigurable;
            if (configurable)
            {
                configurable.config(context);
            }
        }
        
        /* INTERFACE com.okapp.mvc.processors.IProcessor */
        
        public function setup(bean:Link):void
        {
        
        }
    }
}