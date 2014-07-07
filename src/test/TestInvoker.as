package test
{
	import common.entity.BehaviourInvoker;
	import common.entity.BehaviourInvokerFlags;
	import common.system.enums.BitFlagEnum;
	import flash.events.TimerEvent;
	import flash.utils.getTimer;
	import flash.utils.setInterval;
	import flash.utils.Timer;
	
	/**
	 * ...
	 * @author dorofiy.com
	 */
	public class TestInvoker extends BehaviourInvoker
	{
		
		public function TestInvoker()
		{
			super("blabla", BitFlagEnum.combine(BehaviourInvokerFlags.METHOD, BehaviourInvokerFlags.ENABLED));
			
			var timer:Timer = new Timer(1000);
			timer.addEventListener(TimerEvent.TIMER, onTimerHander);
			timer.start();
		}
		
		private function onTimerHander(event:TimerEvent):void 
		{
			invoke(getTimer());
		}
	}
}