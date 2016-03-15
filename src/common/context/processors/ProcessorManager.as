package common.context.processors
{
    import common.context.links.Link;
    import common.context.IContext;
    import common.injection.IInjector;
    import common.system.ClassType;
    import common.system.IDisposable;
    import common.system.Type;
    import common.system.TypeObject;
    import flash.utils.Dictionary;
    
    /**
     * ...
     * @author dorofiy.com
     */
    public class ProcessorManager extends TypeObject implements IDisposable
    {
        private var _processors:Vector.<IProcessor>;
        private var _dictionary:Dictionary;
        private var _context:IContext;
        private var _raw:Vector.<Object>;
        
        public function ProcessorManager(context:IContext)
        {
            _context = context;
            _processors = new Vector.<IProcessor>();
            _dictionary = new Dictionary();
            _raw = new Vector.<Object>();
        }
        
        public function processCollection(beans:Vector.<Link>):void
        {
            for each (var processor:IProcessor in _processors)
            {
                for each (var bean:Link in beans)
                {
                    processor.process(bean);
                }
            }
        }
        
        public function process(bean:Link):void
        {
            for each (var processor:IProcessor in _processors)
            {
                processor.process(bean);
            }
        }
        
        public function install(processor:IProcessor, inject:Boolean = false):void
        {
            if (!(processor in _dictionary))
            {
                _processors[_processors.length] = processor;
                _dictionary[processor] = processor;
                _context.injector.map(ClassType.getAsClass(processor)).toValue(processor);
                if (inject)
                {
                    _context.injector.inject(processor);
                }
            }
        }
        
        /* INTERFACE common.system.IDisposable */
        
        public function dispose():void
        {
            if (_processors)
            {
                var disposable:IDisposable;
                for each (var item:IProcessor in _processors)
                {
                    disposable = item as IDisposable;
                    if (disposable)
                    {
                        disposable.dispose();
                    }
                }
            }
            _processors = null;
            _dictionary = null;
            _raw = null;
            _context = null;
        }
        
        public function injectProcessors():void
        {
            var processor:IProcessor;
            for each (processor in _processors)
            {
                _context.injector.inject(processor);
            }
        }
        
        public function setup(bean:Link):void
        {
            for each (var processor:IProcessor in _processors)
            {
                processor.setup(bean);
            }
        }
        
        public function setupCollection(collection:Vector.<Link>):void
        {
            for each (var processor:IProcessor in _processors)
            {
                for each (var bean:Link in collection)
                {
                    processor.setup(bean);
                }
            }
        }
        
        public function add(item:Object):void 
        {
            _raw[_raw.length] = item;
        }
        
        public function initialize():void 
        {
            var injector:IInjector = _context.injector;
            var type:Type;
            var item:Object;
            for each (item in _raw)
            {
                type = ClassType.getInstanceType(item);
                if (type.isClass)
                {
                    injector.map(type.constructorClass).asSingleton();
                }
                else
                {
                    injector.map(type.constructorClass).toValue(item);
                }
            }
            for each (item in _raw)
            {
                if (item is Class)
                {
                    item = injector.getObject(ClassType.getAsClass(item))
                }
                else
                {
                    injector.inject(item);
                }
            }
            for each (item in _raw)
            {
                if (item is Class)
                {
                    item = injector.getObject(ClassType.getAsClass(item));
                }
                install(IProcessor(item));
            }
            _raw.length = 0;
        }
    }
}