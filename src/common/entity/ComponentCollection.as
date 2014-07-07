package common.entity
{
	import common.system.IDisposable;
	import common.system.TypeObject;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * ...
	 * @author dorofiy.com
	 */
	internal class ComponentCollection extends TypeObject implements IDisposable
	{
		private var _components:Vector.<Component>;
		
		public function ComponentCollection()
		{
			_components = new Vector.<Component>();
		}
		
		public function add(value:Component):void
		{
			_components[_components.length] = value;
		}
		
		public function remove(value:Component):Boolean
		{
			var index:int = _components.indexOf(value);
			if (index != -1)
			{
				_components.splice(index, 1);
				return true;
			}
			return false;
		}
		
		public function contains(value:Component):Boolean
		{
			return _components.indexOf(value) != -1;
		}
		
		public function getByType(type:Class):Component
		{
			for each (var item:Component in _components)
			{
				if (item is type)
				{
					return item;
				}
			}
			return null;
		}
		
		public function getByName(name:String):Component
		{
			for each (var item:Component in _components)
			{
				if (item.name == name)
				{
					return item;
				}
			}
			return null;
		}
		
		public function getBehaviours(context:BehaviourContext):void
		{
			var result:Vector.<Behaviour> = context.behavioursCollection;
			var type:Class = context.type;
			var index:int = context.index;
			for each (var component:Component in _components) 
			{
				if (component is type)
				{
					result[index] = Behaviour(component);
					index++;
				}
			}
			context.index = index;
		}
		
		public function getCollection(type:Class = null, result:Vector.<Component> = null):Vector.<Component>
		{
			if (type == null && result == null)
			{
				return _components.slice();
			}
			if (result == null)
			{
				result = new Vector.<Component>(_components.length);
			}
			var index:int;
			var len:int = _components.length;
			var current:Component;
			for (var i:int = 0; i < len; i++)
			{
				current = _components[i];
				if (type == null || current is type)
				{
					result[index] = current;
					index++;
				}
			}
			result.length = index;
			return result;
		}
		
		public function dispose():void
		{
			if (_components.length > 0)
			{
				for each (var item:Component in _components.slice())
				{
					item.detachComponent();
					item.dispose();
				}
				_components.length = 0;
			}
		}
	}
}