package common.composite
{
	
	/**
	 * ...
	 * @author dorofiy.com
	 */
	public class ComponentEventInvoker extends ComponentBehaviour
	{
		private var _includeInactive:Boolean;
		
		public function ComponentEventInvoker(includeInactive:Boolean = false)
		{
			_includeInactive = includeInactive;
		}
		
		public function dispathEvent(event:Event):void
		{
			if (entity)
			{
				entity.dispatchEvent(event);
			}
		}
		
		public function dispathEventWith(type:String, bubbles:Boolean = false, data:Object = null):void
		{
			if (entity)
			{
				entity.dispatchEventWith(type, bubbles, data);
			}
		}
		
		public function dispathEventAs(eventType:Class, type:String, ... args):void
		{
			if (entity)
			{
				entity.dispatchEventAs.apply(null, args.slice(0, 0, eventType, type));
			}
		}
		
		public function get includeInactive():Boolean
		{
			return _includeInactive;
		}
		
		public function set includeInactive(value:Boolean):void
		{
			_includeInactive = value;
		}
	}
}