package mvc.mediators
{
	import common.injection.providers.IProvider;
	
	/**
	 * ...
	 * @author dorofiy.com
	 */
	public interface IMediatorMap extends IMediatorTarget
	{
		function toFactory(type:Class):IMediatorTarget;
		function asFactory():IMediatorTarget;
		function toValue(value:Object):IMediatorTarget;
		function toSingleton(type:Class, oneInstance:Boolean = true):IMediatorTarget;
		function toProvider(provider:IProvider):IMediatorTarget;
		function asSingleton():IMediatorTarget;
	}

}