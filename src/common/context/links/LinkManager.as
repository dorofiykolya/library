package common.context.links
{
    import common.context.IContext;
    import common.injection.IInjector;
    import common.system.ClassType;
    import common.system.IDisposable;
    import common.system.Type;
    import common.system.TypeObject;
    
    /**
     * Beans collection
     */
    public class LinkManager extends TypeObject implements IDisposable
    {
        private var _beans:Vector.<Link>;
        private var _raw:Vector.<Link>;
        private var _context:IContext;
        
        public function LinkManager(context:IContext)
        {
            _context = context;
            _beans = new <Link>[];
            _raw = new <Link>[];
        }
        
        public function install(bean:Link):Link
        {
            _beans[_beans.length] = bean;
            return bean;
        }
        
        public function get collection():Vector.<Link>
        {
            return _beans.slice();
        }
        
        public function removeBeanById(id:String):Link
        {
            var bean:Link = findBeanById(id);
            if (bean)
            {
                var index:int = _beans.indexOf(bean);
                if (index != -1)
                {
                    _beans.splice(index, 1);
                }
            }
            return bean;
        }
        
        public function removeBeanByType(type:Class):Link
        {
            var bean:Link = findBeanByType(type);
            if (bean)
            {
                var index:int = _beans.indexOf(bean);
                if (index != -1)
                {
                    _beans.splice(index, 1);
                }
            }
            return bean;
        }
        
        public function findBeanById(id:String):Link
        {
            for each (var item:Link in _beans)
            {
                if (item.name == id)
                {
                    return item;
                }
            }
            return null;
        }
        
        public function findBeanByType(type:Class):Link
        {
            for each (var item:Link in _beans)
            {
                if (item.type == type)
                {
                    return item;
                }
            }
            return null;
        }
        
        /* INTERFACE common.system.IDisposable */
        
        public function dispose():void
        {
            if (_beans)
            {
                for each (var bean:IDisposable in _beans)
                {
                    bean.dispose();
                }
                _beans = null;
                _raw = null;
            }
        }
        
        public function add(item:Object):Link 
        {
            var bean:Link;
            if (!(item is Link))
            {
                bean = new Link(item);
            }
            else
            {
                bean = Link(item);
            }
            _raw[_raw.length] = bean;
            return bean;
        }
        
        public function initialize():void 
        {
            var injector:IInjector = _context.injector;
            var type:Type;
            var item:Link;
            for each (item in _raw)
            {
                type = ClassType.getInstanceType(item._instance);
                if (type.isClass)
                {
                    injector.map(item.api).toSingleton(item.type);
                }
                else
                {
                    injector.map(item.api).toValue(item._instance);
                }
            }
            for each (item in _raw)
            {
                if (item._instance is Class)
                {
                    item._instance = injector.getObject(ClassType.getAsClass(item.api));
                }
                else
                {
                    injector.inject(item._instance);
                }
                install(item);
            }
            _raw.length = 0;
        }
    }
}
