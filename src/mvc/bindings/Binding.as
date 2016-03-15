package mvc.bindings
{
    import common.system.IDisposable;
    import common.system.TypeObject;
    import flash.utils.Dictionary;
    
    /**
     * ...
     * @author dorofiy.com
     */
    public class Binding extends TypeObject implements IBinding, IDisposable
    {
        private var _dictionary:Dictionary;
        
        public function Binding()
        {
            _dictionary = new Dictionary();
        }
        
        public function bind(from:Object, fromProperty:String, to:Object, toProperty:String):void
        {
            var chain:Chain = new Chain();
            chain.from = from;
            chain.fromProperty = fromProperty;
            chain.to = to;
            chain.toProperty = toProperty;
            insert(chain);
        }
        
        /* INTERFACE com.okapp.mvc.bindings.IBinding */
        
        public function update(instance:Object, property:String):void
        {
            var current:Dictionary = _dictionary[instance];
            if (current)
            {
                var collection:Vector.<Chain> = current[property];
                if (collection)
                {
                    for each (var chain:Chain in collection)
                    {
                        chain.to[chain.toProperty] = instance[property];
                    }
                }
            }
        }
        
        /* INTERFACE common.system.IDisposable */
        
        public function dispose():void
        {
            _dictionary = null;
        }
        
        private function insert(chain:Chain):void
        {
            var current:Dictionary = _dictionary[chain.from];
            if (current == null)
            {
                current = new Dictionary();
                _dictionary[chain.from] = current;
            }
            var collection:Vector.<Chain> = current[chain.fromProperty];
            if (collection == null)
            {
                collection = new Vector.<Chain>();
                current[chain.fromProperty] = collection;
            }
            for each (var item:Chain in collection)
            {
                if (item.to == chain.to && item.toProperty == chain.toProperty)
                {
                    return;
                }
            }
            collection[collection.length] = chain;
        }
    }
}