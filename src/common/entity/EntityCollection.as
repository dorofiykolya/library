package common.entity
{
	import common.system.ClassType;
	import common.system.collection.Enumerator;
	import common.system.collection.IEnumerator;
	import common.system.IDisposable;
	import common.system.ITypeObject;
	import common.system.Type;
	import flash.utils.flash_proxy
	import flash.utils.Proxy;
	
	/**
	 * ...
	 * @author dorofiy.com
	 */
	public class EntityCollection extends Proxy implements ITypeObject, IChildList, IDisposable
	{
		private var _numChildren:int;
		private var _entity:Entity;
		private var _collection:Vector.<Entity>;
		private var _iteratorCollection:Vector.<Entity>;
		
		public function EntityCollection(entity:Entity)
		{
			_numChildren = 0;
			_entity = entity;
			_collection = new Vector.<Entity>();
		}
		
		public function dispose():void
		{
			for each (var item:IDisposable in this)
			{
				item.dispose();
			}
			_numChildren = 0;
			_collection.length = 0;
		}
		
		/* INTERFACE engine.IChildList */
		
		public function get numChildren():int
		{
			return _numChildren;
		}
		
		public function add(child:Entity):Entity
		{
			return addAt(child, _numChildren);
		}
		
		public function addAt(child:Entity, index:int):Entity
		{
			if (child == null)
			{
				throw new ArgumentError(ClassType.getQualifiedClassName(this) + ", child can not be null");
			}
			if (child == _entity)
			{
				throw new ArgumentError(ClassType.getQualifiedClassName(this) + ", An object cannot be added as a child to itself or one " + "of its children (or children's children, etc.)");
			}
			if (index >= 0 && index <= _numChildren)
			{
				if (child._parent != _entity)
				{
					if (child._parent != null)
					{
						child._parent._children.remove(child);
					}
					if (index == _numChildren)
					{
						_collection[_numChildren] = child;
					}
					else
					{
						_collection.splice(index, 0, child);
					}
					_numChildren++;
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
		
		public function swap(child1:Entity, child2:Entity):void
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
			var child1:Entity = getAt(index1);
			var child2:Entity = getAt(index2);
			_collection[index1] = child2;
			_collection[index2] = child1;
		}
		
		public function setIndex(child:Entity, index:int):void
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
		
		public function getIndex(child:Entity):int
		{
			return _collection.indexOf(child);
		}
		
		public function getByName(name:String):Entity
		{
			for each (var item:Entity in _collection)
			{
				if (item._name == name)
				{
					return item;
				}
			}
			return null;
		}
		
		public function remove(child:Entity):Boolean
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
		
		public function removeAt(index:int):Entity
		{
			if (index >= 0 && index < _numChildren)
			{
				var child:Entity = _collection[index];
				child.setParent(null);
				_collection.splice(index, 1);
				_numChildren--;
				child.detachFromParent();
				return child;
			}
			return null;
		}
		
		public function getChildren():Vector.<Entity>
		{
			return _collection.slice();
		}
		
		public function contains(child:Entity, includingChildren:Boolean = false):Boolean
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
						child = child._parent;
				}
				return false;
			}
			return child._parent == _entity;
		}
		
		internal function getComponents(type:Class = null, includeInactive:Boolean = false):Vector.<Component>
		{
			var component:Component;
			var result:Vector.<Component> = new Vector.<Component>();
			for each (var entity:Entity in _collection)
			{
				for each (component in entity.getComponents(type))
				{
					if (includeInactive || component._enabled)
					{
						result[result.length] = component;
					}
				}
			}
			return result;
		}
		
		internal function getComponentsInChildren(type:Class = null, includeInactive:Boolean = false):Vector.<Component>
		{
			var component:Component;
			var result:Vector.<Component> = new Vector.<Component>();
			for each (var entity:Entity in _collection)
			{
				for each (component in entity.getComponents(type))
				{
					if (includeInactive || component._enabled)
					{
						result[result.length] = component;
					}
				}
				for each (component in entity.getComponentsInChildren(type))
				{
					if (includeInactive || component._enabled)
					{
						result[result.length] = component;
					}
				}
			}
			return result;
		}
		
		public function removeAll():void
		{
			_collection.length = 0;
			_numChildren = 0;
		}
		
		public function getAt(index:int):Entity
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
			if (index < _numChildren)
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
			_collection[index] = Entity(value);
		}
		
		/* INTERFACE common.system.ITypeObject */
		
		public function getType():Type
		{
			return ClassType.getType(this);
		}
		
		/* INTERFACE common.entity.IChildList */
		
		public function addRange(collection:Vector.<Entity>):void
		{
			if (collection == null)
			{
				throw new ArgumentError(ClassType.getQualifiedClassName(this) + ", collection can not be null");
			}
			for each (var item:Entity in collection)
			{
				addAt(item, _numChildren);
			}
		}
		
		public function getByType(type:Class):Entity
		{
			if (type != Entity && ClassType.isSubclassOf(type, Entity) == false)
			{
				throw new ArgumentError(ClassType.getQualifiedClassName(this) + ", type must extend the " + ClassType.getQualifiedClassName(Entity));
			}
			for each (var item:Entity in _collection)
			{
				if (item is type)
				{
					return item;
				}
			}
			return null;
		}
		
		public function getRange(index:int, count:int):Vector.<Entity>
		{
			if (index >= _numChildren)
			{
				throw new RangeError("Invalid index");
			}
			return _collection.slice(index, index + count);
		}
		
		public function removeRange(index:int, count:int):Vector.<Entity>
		{
			if (index < 0 || index >= _numChildren)
			{
				throw new RangeError("Invalid index");
			}
			return _collection.splice(index, count);
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
	}
}