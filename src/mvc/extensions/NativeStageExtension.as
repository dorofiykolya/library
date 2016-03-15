package mvc.extensions
{
    import common.context.IContext;
    import common.system.IDisposable;
    import common.system.TypeObject;
    import flash.display.Stage;
    
    /**
     * ...
     * @author dorofiy.com
     */
    public class NativeStageExtension extends TypeObject implements IExtension, IDisposable
    {
        private var _stage:Stage;
        
        public function NativeStageExtension(stage:Stage)
        {
            _stage = stage;
        }
        
        /* INTERFACE common.system.IDisposable */
        
        public function dispose():void
        {
            _stage = null;
        }
        
        /* INTERFACE com.okapp.mvc.extensions.IExtension */
        
        public function extend(context:IContext):void
        {
            context.injector.map(Stage).toValue(_stage);
        }
    }
}