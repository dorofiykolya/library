package mvc.mediators
{
	import common.injection.IInjector;
	import common.context.links.Link;
	import common.context.IContext;
	import common.injection.Injector;
	import flash.errors.IllegalOperationError;
	
	/**
	 * ...
	 * @author dorofiy.com
	 */
	public class MediatorContext implements IMediatorContext
	{
		private var _injector:Injector;
		private var _parent:IContext;
		
		public function MediatorContext(context:IContext = null)
		{
			if (context != null)
			{
				_parent = context;
				_injector = new Injector(context.injector);
			}
			else
			{
				_injector = new Injector();
			}
		}
		
		/* INTERFACE mvc.mediators.IMediatorContext */
		
		public function unmap(type:Class):void
		{
			_injector.unmap(type);
		}
		
		public function map(type:Class):IMediatorMap
		{
			var result:MediatorMap = _injector.getProvider(type) as MediatorMap;
			if (result == null)
			{
				_injector.map(type).toProvider((result = new MediatorMap(_injector, type)));
			}
			return result;
		}
		
		public function install(... extensions):IContext
		{
			throw new IllegalOperationError("not implemented");
		}
		
		public function getObject(type:Class, name:String = null):Object
		{
			return _injector.getObject(type, name);
		}
		
		public function get injector():IInjector
		{
			return _injector;
		}
		
		public function get parent():IContext
		{
			return _parent;
		}
	
	}

}