package common.context
{
	import common.context.IContext;
    import common.context.links.Link;
    import common.context.links.LinkManager;
    import common.context.extensions.ExtensionManager;
    import common.context.extensions.IExtension;
    import common.context.processors.IProcessor;
    import common.context.processors.ProcessorManager;
    import common.injection.IInjector;
    import common.injection.Injector;
    import common.system.Assert;
    import common.system.ClassType;
    import common.system.Type;
    import common.system.TypeObject;
    
    /**
     * ...
     * @author dorofiy.com
     */
    public class Context extends TypeObject implements IContext
    {
        //--------------------------------------------------------------------------
        //     
        //	PRIVATE VARIABLES 
        //     
        //--------------------------------------------------------------------------
        
        private var _initialized:Boolean;
        private var _injector:Injector;
        private var _parent:IContext;
        private var _extensionManager:ExtensionManager;
        private var _beanManager:LinkManager;
        private var _processorManager:ProcessorManager;
        
        //----------------------------------
        //	CONSTRUCTOR
        //----------------------------------
        
        public function Context(parent:IContext = null)
        {
            _injector = new Injector();
            _parent = parent;
            if (_parent)
            {
                _injector.parent = _parent.injector;
            }
            _extensionManager = new ExtensionManager(this);
            _beanManager = new LinkManager(this);
            _processorManager = new ProcessorManager(this);
            
            _injector.map(IInjector).toValue(_injector);
            _injector.map(Injector).toValue(_injector);
            _injector.map(IContext).toValue(this);
            _injector.map(Context).toValue(this);
        }
        
        /* INTERFACE com.okapp.mvc.IContext */
        
        public function install(... extensions):IContext
        {
            var itemType:Type;
            var beans:Vector.<Link>;
            var bean:Link;
            
            if (_initialized)
            {
                beans = new Vector.<Link>();
            }
            
            for each (var item:Object in extensions)
            {
                itemType = ClassType.getInstanceType(item);
                if (itemType.isInstanceOf(IExtension))
                {
                    _extensionManager.add(item);
                }
                else if (itemType.isInstanceOf(IProcessor))
                {
                    _processorManager.add(item);
                }
                else
                {
                    bean = _beanManager.add(item);
                    if (_initialized)
                    {
                        beans[beans.length] = bean;
                    }
                }
            }
            if (_initialized)
            {
                _extensionManager.initialize();
                _beanManager.initialize();
                _processorManager.initialize();
                _processorManager.setupCollection(beans);
                _processorManager.processCollection(beans);
            }
            return this;
        }
        
        public function getBean(nameOrType:Object):Link
        {
            Assert.notNull(nameOrType, "nameOrType, this argument is required; it must not null");
            var type:Class = nameOrType is Class ? Class(nameOrType) : null;
            var id:String = nameOrType is String ? String(nameOrType) : null;
            if (type)
            {
                return _beanManager.findBeanByType(type);
            }
            Assert.hasText(id, "nameOrType:string, this argument must have text; it must not be null, empty or blank");
            return _beanManager.findBeanById(id);
        }
        
        public function getBeans(type:Class):Vector.<Link>
        {
            var result:Vector.<Link> = new Vector.<Link>();
            var instance:Object;
            for each (var item:Link in _beanManager.collection)
            {
                instance = item.instance;
                if (instance is type)
                {
                    result[result.length] = item;
                }
            }
            return result;
        }
        
        /* INTERFACE com.okapp.mvc.IContext */
        
        public function getObjects(type:Class):Vector.<Object>
        {
            var result:Vector.<Object> = new Vector.<Object>();
            var instance:Object;
            for each (var item:Link in _beanManager.collection)
            {
                instance = item.instance;
                if (instance is type)
                {
                    result[result.length] = instance;
                }
            }
            return result;
        }
        
        public function getObject(type:Class, name:String = null):Object
        {
            return _injector.getObject(type, name);
        }
        
        public function map(value:Object):void
        {
            var clazz:Class = ClassType.getAsClass(value);
            if (value == clazz)
            {
                _injector.map(clazz).asSingleton();
            }
            else
            {
                _injector.map(clazz).toValue(value);
            }
        }
        
        public function get injector():IInjector
        {
            return _injector;
        }
        
        public function get parent():IContext
        {
            return _parent;
        }
        
        public function set parent(value:IContext):void
        {
            _parent = value;
            if (value != null)
                _injector.parent = value.injector;
            else
                _injector.parent = null;
        }
		
		public function get initialized():Boolean 
		{
			return _initialized;
		}
        
        //----------------------------------
        //	initialize
        //----------------------------------
        public function initialize():void
        {
            if (!_initialized)
            {
                initializeContent();
                _initialized = true;
            }
        }
        
        //--------------------------------------------------------------------------
        //     
        //	PRIVATE SECTION 
        //     
        //--------------------------------------------------------------------------
        
        protected function initializeContent():void
        {
            _extensionManager.initialize();
            _beanManager.initialize();
            _processorManager.initialize();
            _processorManager.setupCollection(_beanManager.collection);
            _processorManager.processCollection(_beanManager.collection);
        }
    }
}