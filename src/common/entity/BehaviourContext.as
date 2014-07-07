package common.entity
{
	import common.system.enums.BitFlagEnum;
	import common.system.TypeObject;
	
	/**
	 * ...
	 * @author dorofiy.com
	 */
	public class BehaviourContext extends TypeObject
	{
		private static const POOL:Vector.<BehaviourContext> = new Vector.<BehaviourContext>(64);
		private static var _poolIndex:int = 0;
		
		internal var args:Array;
		internal var behavioursCollection:Vector.<Behaviour>;
		internal var index:int;
		internal var type:Class;
		internal var recursive:Boolean;
		internal var isMethod:Boolean;
		internal var isEnabled:Boolean;
		internal var isDisabled:Boolean;
		internal var isComponentType:Boolean;
		
		private var _flags:uint;
		
		public function BehaviourContext()
		{
			behavioursCollection = new Vector.<Behaviour>(1024);
			index = 0;
			recursive = true;
		}
		
		internal static function getInstance():BehaviourContext
		{
			if (_poolIndex > 0)
			{
				return POOL[int(--_poolIndex)];
			}
			return new BehaviourContext();
		}
		
		internal static function putInstance(value:BehaviourContext):void
		{
			POOL[_poolIndex] = value;
			_poolIndex++;
		}
		
		internal function dispose():void
		{
			behavioursCollection.length = 0;
			index = 0;
			recursive = true;
			isMethod = false;
			isEnabled = false;
			isDisabled = false;
			isComponentType = false;
		}
		
		public function get flags():uint
		{
			return _flags;
		}
		
		public function set flags(value:uint):void
		{
			_flags = value;
			isMethod = BitFlagEnum.getFlag(value, BehaviourInvokerFlags.METHOD);
			isEnabled = BitFlagEnum.getFlag(value, BehaviourInvokerFlags.ENABLED);
			isDisabled = BitFlagEnum.getFlag(value, BehaviourInvokerFlags.DISABLED);
			isComponentType = BitFlagEnum.getFlag(value, BehaviourInvokerFlags.COMPONENT_TYPE);
		}
	}
}