package common.system.utils 
{
	import common.system.IDisposable;
	
	/**
	 * ...
	 * @author dorofiy.com
	 */
	public interface IPoolable extends IDisposable
	{
		function get poolRef():PoolRef;
		function reinitialize():void;
	}
	
}