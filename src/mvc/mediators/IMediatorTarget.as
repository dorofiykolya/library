package mvc.mediators
{
	
	/**
	 * ...
	 * @author dorofiy.com
	 */
	public interface IMediatorTarget
	{
		function target(type:Class, provider:IMediatorProvider = null):IMediatorMap;
		function targetProvider(provider:IMediatorProvider):IMediatorMap;
	}

}