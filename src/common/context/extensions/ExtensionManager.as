package common.context.extensions
{
    import common.context.IContext;
    import common.injection.IInjector;
    import common.system.ClassType;
    import common.system.IDisposable;
    import common.system.Type;
    import common.system.TypeObject;
    
    /**
     * ...
     * @author dorofiy.com
     */
    public class ExtensionManager extends TypeObject implements IDisposable
    {
        private var _context:IContext;
        private var _extensions:Vector.<IExtension>;
        private var _raw:Vector.<Object>;
        
        public function ExtensionManager(context:IContext)
        {
            _context = context;
            _extensions = new Vector.<IExtension>();
            _raw = new Vector.<Object>();
        }
        
        /* INTERFACE common.system.IDisposable */
        
        public function dispose():void
        {
            if (_extensions)
            {
                var disposable:IDisposable;
                for each (var item:IExtension in _extensions)
                {
                    disposable = item as IDisposable;
                    if (disposable)
                    {
                        disposable.dispose();
                    }
                }
            }
            _extensions = null;
            _context = null;
            _raw = null;
        }
        
        public function initialize():void
        {
            initializeExtensions(_raw);
            _raw.length = 0;
        }
        
        private function initializeExtensions(collection:Object):void
        {
            var injector:IInjector = _context.injector;
            var type:Type;
            var item:Object;
            var index:int = 0;
            for each (item in collection)
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
                type = null;
                item = null;
            }
            for each (item in collection)
            {
                if (item is Class)
                {
                    injector.getObject(ClassType.getAsClass(item));
                }
                else
                {
                    injector.inject(item);
                }
                item = null;
            }
            for each (item in collection)
            {
                var result:IExtension = null;
                if (item is Class)
                {
                    result = injector.getObject(ClassType.getAsClass(item)) as IExtension;
                }
                else
                {
                    result = item as IExtension;
                }
                if (result == null)
                {
                    initializeExtensions(collection.slice(index));
                    result = null;
                    return;
                }
                install(result);
                index++;
                result = null;
            }
            injector = null;
            type = null;
            item = null;
        }
        
        public function install(extension:IExtension):void
        {
            if (_extensions.indexOf(extension) == -1)
            {
                _extensions[_extensions.length] = extension;
                extension.extend(_context);
            }
        }
        
        public function add(item:Object):void 
        {
            _raw[_raw.length] = item;
        }
    }
}