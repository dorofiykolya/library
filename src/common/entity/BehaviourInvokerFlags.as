package common.entity
{
	import common.system.enums.BitFlagEnum;
	
	/**
	 * ...
	 * @author dorofiy.com
	 */
	public class BehaviourInvokerFlags extends BitFlagEnum
	{
		/**
		 * 1 (0x1)
		 */
		public static const ENABLED:BehaviourInvokerFlags = new BehaviourInvokerFlags();
		/**
		 * 2 (0x2)
		 */
		public static const DISABLED:BehaviourInvokerFlags = new BehaviourInvokerFlags();
		/**
		 * 3 (0x4)
		 */
		public static const COMPONENT_TYPE:BehaviourInvokerFlags = new BehaviourInvokerFlags();
		/**
		 * 4 (0x8)
		 */
		public static const METHOD:BehaviourInvokerFlags = new BehaviourInvokerFlags();
		
		public function BehaviourInvokerFlags()
		{
		
		}
	}
}