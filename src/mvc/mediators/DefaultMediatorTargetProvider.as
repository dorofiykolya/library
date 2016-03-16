package mvc.mediators
{
	
	/**
	 * ...
	 * @author dorofiy.com
	 */
	public class DefaultMediatorTargetProvider extends DefaultTargetProvider
	{
		private var _target:IMediator;
		
		public function DefaultMediatorTargetProvider()
		{
		
		}
		
		public override function provide(mediator:Object, expected:Class):void
		{
			super.provide(mediator, expected);
			_target = mediator as IMediator;
			if (_target != null)
			{
				_target.mediate(_expectedResult);
			}
		}
		
		public override function unProvide():void
		{
			if (_target != null)
			{
				_target.unmediate();
				_target = null;
			}
			super.unProvide();
		}
		
		public override function dispose():void
		{
			super.dispose();
			_target = null;
		}
	}
}