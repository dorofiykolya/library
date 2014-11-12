package common.injection.providers
{
    import common.injection.IInjector;
	import common.injection.Injector;
	import common.system.IDisposable;
	
	/**
	 * ...
	 * @author dorofiy.com
	 */
	public interface IProvider extends IDisposable
	{
		function apply(injector:IInjector, type:Class):Object;
	}
}