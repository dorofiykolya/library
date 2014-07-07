package common.system.io.serialization.binary
{
	import common.system.ClassType;
	import common.system.errors.AbstractClassError;
	import common.system.errors.AbstractMethodError;
	import common.system.TypeObject;
	import flash.utils.ByteArray;
	
	/**
	 * ...
	 * @author dorofiy.com
	 */
	public class BinaryReader extends TypeObject implements IBinaryReader
	{
		
		public function BinaryReader()
		{
			if (Object(this).constructor === BinaryReader)
			{
				throw new AbstractClassError('AbstractClassError: ' + ClassType.getQualifiedClassName(this) + ' class cannot be instantiated.');
			}
		}
		
		public function read(buffer:ByteArray):Object
		{
			throw new AbstractMethodError("Method needs to be implemented in subclass");
		}
	}
}