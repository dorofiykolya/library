package common.system.io.serialization.binary
{
	import flash.utils.ByteArray;
	
	/**
	 * ...
	 * @author dorofiy.com
	 */
	public interface IBinaryReader
	{
		function read(buffer:ByteArray):Object;
	}

}