package mvc.mediators
{
	import common.context.IContext;
	
	/**
	 * ...
	 * @author dorofiy.com
	 */
	public interface IMediatorContext extends IContext
	{
		function unmap(type:Class):void;
		function map(type:Class):IMediatorMap;
	}

}