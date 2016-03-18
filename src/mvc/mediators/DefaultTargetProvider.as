package mvc.mediators
{
	import common.injection.IInjector;
	import common.system.IDisposable;
	
	/**
	 * ...
	 * @author dorofiy.com
	 */
	public class DefaultTargetProvider implements IMediatorProvider
	{
		[Inject]
		public var injector:IInjector;
		protected var _expectedResult:Object;
		
		public function DefaultTargetProvider()
		{
		
		}
		
		/* INTERFACE mvc.mediators.IMediatorProvider */
		
		public function provide(mediator:Object, expected:Class):void
		{
			injector.map(expected).asSingleton();
			_expectedResult = injector.getObject(expected);
			injector.inject(mediator);
			injector.unmap(expected);
		}
		
		public function unProvide():void
		{
			if (_expectedResult != null)
			{
				var disposable:IDisposable = _expectedResult as IDisposable;
				if (disposable != null)
				{
					disposable.dispose();
				}
				_expectedResult = null;
			}
		}
		
		public function dispose():void
		{
			unProvide();
			injector = null;
			_expectedResult = null;
		}
	
	}

}