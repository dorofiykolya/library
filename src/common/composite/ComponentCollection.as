package common.composite
{
    import common.system.Assert;
    import common.system.ClassType;
    import common.system.collection.Enumerator;
    import common.system.collection.IEnumerator;
    import common.system.IDisposable;
    import common.system.ITypeObject;
    import common.system.Type;
    import common.system.TypeObject;
    import flash.utils.flash_proxy;
    import flash.utils.getQualifiedClassName;
    import flash.utils.Proxy;
    
    /**
     * ...
     * @author dorofiy.com
     */
    internal class ComponentCollection extends Proxy implements ITypeObject, IComponentCollection, IDisposable
    {
        internal var _count:int;
        internal var _entity:Entity;
        internal var _collection:Vector.<Component>;
        internal var _iteratorCollection:Vector.<Component>;
        
        public function ComponentCollection(entity:Entity)
        {
            _count = 0;
            _entity = entity;
            _collection = new Vector.<Component>();
        }
        
        internal function getComponentsByContext(context:ComponentContext):void
        {
            var result:Vector.<Component> = context.componentsCollection;
            var type:Class = context.type;
            var entity:Entity;
            for each (var component:Component in _collection)
            {
                if (component is type)
                {
                    entity = component as Entity;
                    if (entity)
                    {
                        entity.getComponentsByContext(context);
                    }
                    else
                    {
                        result[context.index] = component;
                        context.index++;
                    }
                }
            }
            result[context.index] = _entity;
            context.index++;
        }
        
        /* INTERFACE engine.IChildList */
        
        public function get count():int
        {
            return _count;
        }
        
        public function get components():Vector.<Component>
        {
            return _collection.slice();
        }
        
        public function add(child:Component):Component
        {
            return addAt(child, _count);
        }
        
        public function addAt(child:Component, index:int):Component
        {
            if (child == null)
            {
                throw new ArgumentError(ClassType.getQualifiedClassName(this) + ", child can not be null");
            }
            if (child == _entity)
            {
                throw new ArgumentError(ClassType.getQualifiedClassName(this) + ", An object cannot be added as a child to itself or one " + "of its children (or children's children, etc.)");
            }
            if (index >= 0 && index <= _count)
            {
                if (child.parent != _entity)
                {
                    if (child.parent != null)
                    {
                        child.parent._components.remove(child);
                    }
                    if (index == _count)
                    {
                        _collection[_count] = child;
                    }
                    else
                    {
                        _collection.splice(index, 0, child);
                    }
                    _count++;
                    child.setParent(_entity);
                    child.attachToParent();
                }
            }
            else
            {
                throw new RangeError("Invalid child index");
            }
            return child;
        }
        
        public function swap(child1:Component, child2:Component):void
        {
            var index1:int = getIndex(child1);
            var index2:int = getIndex(child2);
            if (index1 == -1 || index2 == -1)
            {
                throw new ArgumentError("Not a child of this entity");
            }
            swapIndex(index1, index2);
        }
        
        public function swapIndex(index1:int, index2:int):void
        {
            var child1:Component = getAt(index1);
            var child2:Component = getAt(index2);
            _collection[index1] = child2;
            _collection[index2] = child1;
        }
        
        public function setIndex(child:Component, index:int):void
        {
            var oldIndex:int = getIndex(child);
            if (oldIndex == index)
            {
                return;
            }
            if (oldIndex == -1)
            {
                throw new ArgumentError("Not a child of this entity");
            }
            _collection.splice(oldIndex, 1);
            _collection.splice(index, 0, child);
        }
        
        public function getIndex(child:Component):int
        {
            return _collection.indexOf(child);
        }
        
        public function getByName(name:String):Component
        {
            for each (var item:Component in _collection)
            {
                if (item._name == name)
                {
                    return item;
                }
            }
            return null;
        }
        
        public function remove(child:Component):Boolean
        {
            if (child == null)
            {
                throw new ArgumentError(ClassType.getQualifiedClassName(this) + ", child can not be null");
            }
            if (child == _entity)
            {
                throw new ArgumentError(ClassType.getQualifiedClassName(this) + ", An object cannot be removed as a child to itself or one " + "of its children (or children's children, etc.)");
            }
            var index:int = getIndex(child);
            if (index != -1)
            {
                return removeAt(index) != null;
            }
            return false;
        }
        
        public function removeAt(index:int):Component
        {
            if (index >= 0 && index < _count)
            {
                var child:Component = _collection[index];
                child.detachFromParent();
                child.setParent(null);
                index = _collection.indexOf(child);
                if (index >= 0)
                {
                    _collection.splice(index, 1);
                    _count--;
                }
                return child;
            }
            return null;
        }
        
        public function getCollection():Vector.<Component>
        {
            return _collection.slice();
        }
        
        public function contains(child:Component, includingChildren:Boolean = false):Boolean
        {
            if (child == null)
            {
                throw new ArgumentError(ClassType.getQualifiedClassName(this) + ", child can not be null");
            }
            if (child == _entity)
            {
                throw new ArgumentError(ClassType.getQualifiedClassName(this) + ", An object cannot be added as a child to itself or one " + "of its children (or children's children, etc.)");
            }
            if (includingChildren)
            {
                while (child)
                {
                    if (child == _entity)
                        return true;
                    else
                        child = child.parent;
                }
                return false;
            }
            return child.parent == _entity;
        }
        
        internal function getComponents(type:Class = null, includeInactive:Boolean = false, result:Vector.<Component> = null):Vector.<Component>
        {
            var component:Component;
            result ||= new Vector.<Component>();
            var index:int = result.length;
            for each (component in _collection)
            {
                if ((type == null || component is type) && (includeInactive || component._enabled))
                {
                    result[index] = component;
                    index++;
                }
            }
            result.length = index;
            return result;
        }
        
        internal function getComponentsInChildren(type:Class = null, recursive:Boolean = false, includeInactive:Boolean = false, result:Vector.<Component> = null):Vector.<Component>
        {
            var component:Component;
            var innerComponent:Component;
            var entity:Entity;
            result ||= new Vector.<Component>();
            var index:int = result.length;
            for each (component in _collection)
            {
                if ((type == null || component is type) && (includeInactive || component._enabled))
                {
                    entity = component as Entity;
                    if (entity)
                    {
                        for each (innerComponent in entity.getComponentsInChildren(type, recursive, includeInactive))
                        {
                            if ((type == null || component is type) && (includeInactive || component._enabled))
                            {
                                result[index] = component;
                                index++;
                            }
                        }
                    }
                    result[index] = component;
                    index++;
                }
            }
            result.length = index;
            return result;
        }
        
        public function removeAll():void
        {
            removeRange();
            _collection.length = 0;
            _count = 0;
        }
        
        public function getAt(index:int):Component
        {
            return _collection[index];
        }
        
        /* INTERFACE flash.utils.Proxy */
        
        flash_proxy override function getProperty(name:*):*
        {
            var index:int = int(name);
            return _collection[index];
        }
        
        flash_proxy override function hasProperty(name:*):Boolean
        {
            var index:int = int(name);
            return index in _collection;
        }
        
        flash_proxy override function nextName(index:int):String
        {
            return String(int(index - 1));
        }
        
        flash_proxy override function nextNameIndex(index:int):int
        {
            if (index == 0)
            {
                _iteratorCollection = _collection.slice();
            }
            if (index < _count)
            {
                return index + 1;
            }
            return 0;
        }
        
        flash_proxy override function nextValue(index:int):*
        {
            return _iteratorCollection[int(index - 1)];
        }
        
        flash_proxy override function setProperty(name:*, value:*):void
        {
            var index:int = int(name);
            _collection[index] = Component(value);
        }
        
        /* INTERFACE common.system.ITypeObject */
        
        public function getType():Type
        {
            return ClassType.getType(this);
        }
        
        /* INTERFACE common.entity.IChildList */
        
        public function addRange(collection:Vector.<Component>):void
        {
            if (collection == null)
            {
                throw new ArgumentError(ClassType.getQualifiedClassName(this) + ", collection can not be null");
            }
            for each (var item:Component in collection)
            {
                addAt(item, _count);
            }
        }
        
        public function getByType(type:Class):Component
        {
            if (type != Component && ClassType.isSubclassOf(type, Component) == false)
            {
                throw new ArgumentError(ClassType.getQualifiedClassName(this) + ", type must extend the " + ClassType.getQualifiedClassName(Component));
            }
            for each (var item:Component in _collection)
            {
                if (item is type)
                {
                    return item;
                }
            }
            return null;
        }
        
        public function getRange(index:int, count:int):Vector.<Component>
        {
            if (index >= _count)
            {
                throw new RangeError("Invalid index");
            }
            return _collection.slice(index, index + count);
        }
        
        public function removeRange(beginIndex:int = 0, endIndex:int = -1):Vector.<Component>
        {
            if (beginIndex < 0 || endIndex >= _count)
            {
                throw new RangeError("Invalid index");
            }
            
            var result:Vector.<Component> = new Vector.<Component>();
            if (endIndex < 0 || endIndex >= _count)
            {
                endIndex = _count - 1;
            }
            for (var i:int = beginIndex; i <= endIndex; ++i)
            {
                result[result.length] = removeAt(beginIndex);
            }
            return result;
        }
        
        public function reverse():void
        {
            _collection.reverse();
        }
        
        public function sort(sortFunction:Function):void
        {
            _collection.sort(sortFunction);
        }
        
        public function getEnumerator():IEnumerator
        {
            return new Enumerator(_collection);
        }
        
        /* INTERFACE common.system.IDisposable */
        
        public function dispose():void
        {
            var temp:Vector.<Component> = _collection.slice();
            var index:int = temp.length;
            while(index > 0)
            {
                --index;
                temp[index].dispose();
            }
            _iteratorCollection = null;
            _count = 0;
            _collection.length = 0;
        }
    }
}