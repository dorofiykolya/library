package common.system.io.serialization.binary.json 
{
	import common.system.IDisposable;
	import common.system.TypeObject;
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author dorofiy.com
	 */
	public class BinaryJSON extends TypeObject implements IDisposable
	{
		private var _reader:BinaryJSONReader;
		private var _writer:BinaryJSONWriter;
		
		public function BinaryJSON() 
		{
			_reader = new BinaryJSONReader();
			_writer = new BinaryJSONWriter();
		}
		
		/**
		 * 
		 * @param	binaryJSON
		 * @return
		 */
		public function read(binaryJSON:ByteArray):Object
		{
			return _reader.read(binaryJSON);
		}
		
		/**
		 * 
		 * @param	json
		 * @return
		 */
		public function write(json:Object):ByteArray
		{
			return _writer.write(json);
		}
		
		/* INTERFACE common.system.IDisposable */
		
		public function dispose():void 
		{
			if (_reader)
			{
				_reader.dispose();
				_reader = null;
			}
			if (_writer)
			{
				_writer.dispose();
				_writer = null;
			}
		}
	}
}