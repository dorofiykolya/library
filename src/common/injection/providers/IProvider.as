package common.injection.providers
{
	import common.injection.Injector;
	import common.system.IDisposable;
	
	/**
	 * ...
	 * @author dorofiy.com
	 */
	public interface IProvider extends IDisposable
	{
		function apply(injector:Injector, type:Class):Object;
	}
}