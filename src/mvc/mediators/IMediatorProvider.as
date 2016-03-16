package mvc.mediators
{
	import common.system.IDisposable;
	
	/**
	 * ...
	 * @author dorofiy.com
	 */
	public interface IMediatorProvider extends IDisposable
	{
		function provide(mediator:Object, expected:Class):void;
		function unProvide():void;
	}

}