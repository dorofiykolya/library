package common.injection.maps
{
	import common.injection.providers.IProvider;
	import common.system.IDisposable;
	
	/**
	 * ...
	 * @author dorofiy.com
	 */
	public interface IMapping extends IDisposable
	{
		function get provider():IProvider;
		function toFactory(type:Class):void;
		function toValue(value:Object):void;
		function toSingleton(type:Class):void;
		function toProvider(provider:IProvider):void;
		function asSingleton():void;
	}
}