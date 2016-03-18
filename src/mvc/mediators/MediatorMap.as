package mvc.mediators
{
	import common.injection.IInjector;
	import common.injection.Injector;
	import common.injection.providers.FactoryProvider;
	import common.injection.providers.IProvider;
	import common.injection.providers.SingletonProvider;
	import common.injection.providers.ValueProvider;
	import common.system.ClassType;
	import common.system.IDisposable;
	import common.system.errors.IllegalArgumentError;
	
	/**
	 * ...
	 * @author dorofiy.com
	 */
	public class MediatorMap implements IMediatorMap, IProvider
	{
		protected var _injector:IInjector;
		protected var _provider:IProvider;
		protected var _expected:Class;
		protected var _mediatorProvider:IMediatorProvider;
		protected var _mediatorProviderType:Class;
		protected var _mapType:Class;
		protected var _provided:Boolean;
		
		private var _result:Object;
		
		public function MediatorMap(injector:Injector, mapType:Class)
		{
			_injector = injector;
			_mapType = mapType;
		}
		
		public function toFactory(type:Class):IMediatorTarget
		{
			if (ClassType.isInterface(type))
			{
				throw new IllegalArgumentError("type can't bee an interface");
			}
			return toProvider(new FactoryProvider(_mapType, type));
		}
		
		public function asFactory():IMediatorTarget
		{
			return toFactory(_mapType);
		}
		
		public function toValue(value:Object):IMediatorTarget
		{
			return toProvider(new ValueProvider(_mapType, value));
		}
		
		public function toSingleton(type:Class, oneInstance:Boolean = true):IMediatorTarget
		{
			if (ClassType.isInterface(type))
			{
				throw new IllegalArgumentError("type can't bee an interface");
			}
			return toProvider(new SingletonProvider(_mapType, type, oneInstance));
		}
		
		public function toProvider(provider:IProvider):IMediatorTarget
		{
			_provider = provider;
			return this;
		}
		
		public function asSingleton():IMediatorTarget
		{
			return toSingleton(_mapType);
		}
		
		public function target(type:Class, provider:IMediatorProvider = null):IMediatorMap
		{
			disposeTarget();
			_expected = type;
			_mediatorProvider = provider;
			return this;
		}
		
		public function targetProvider(provider:IMediatorProvider):IMediatorMap
		{
			disposeTarget();
			_expected = null;
			_mediatorProvider = provider;
			return this;
		}
		
		public function apply(injector:IInjector, type:Class):Object
		{
			if (_provider == null)
			{
				asSingleton();
			}
			_result = _provider.apply(injector, type);
			if (!_provided)
			{
				_provided = true;
				applyMediatorProvider(_result);
			}
			return _result;
		}
		
		protected function disposeTarget():void
		{
			if (_mediatorProvider != null)
			{
				_mediatorProvider.unProvide();
				_mediatorProvider.dispose();
				_mediatorProvider = null;
			}
			_mediatorProviderType = null;
			_provided = false;
		}
		
		protected function applyMediatorProvider(result:Object):void
		{
			_mediatorProvider = getMediatorProvider();
			_injector.inject(_mediatorProvider);
			_mediatorProvider.provide(result, _expected);
		}
		
		protected function getMediatorProvider():IMediatorProvider
		{
			if (_mediatorProvider == null)
			{
				if (_mediatorProviderType != null)
				{
					_injector.map(_mediatorProviderType).asFactory();
					_mediatorProvider = _injector.getObject(_mediatorProviderType) as IMediatorProvider;
					_injector.unmap(_mediatorProviderType);
				}
				else
				{
					_mediatorProvider = new DefaultTargetProvider();
				}
			}
			return _mediatorProvider;
		}
		
		public function dispose():void
		{
			disposeTarget();
			if (_result != null)
			{
				var disposable:IDisposable = _result as IDisposable;
				if (disposable != null)
				{
					disposable.dispose();
				}
				_result = null;
			}
			_provided = false;
			_injector = null;
			_provider = null;
			_expected = null;
			_mediatorProvider = null;
			_mapType = null;
		}
	
	}

}