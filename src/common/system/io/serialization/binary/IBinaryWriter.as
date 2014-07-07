package common.system.io.serialization.binary
{
	import flash.utils.ByteArray;
	
	/**
	 * ...
	 * @author dorofiy.com
	 */
	public interface IBinaryWriter
	{
		function write(value:Object):ByteArray;
	}

}