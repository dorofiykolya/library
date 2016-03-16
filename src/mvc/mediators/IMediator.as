package mvc.mediators 
{
	
	/**
	 * ...
	 * @author dorofiy.com
	 */
	public interface IMediator 
	{
		function mediate(target:Object):void;
		function unmediate():void;
	}
	
}