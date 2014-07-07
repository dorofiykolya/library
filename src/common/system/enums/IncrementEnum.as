package common.system.enums
{
	import common.system.Enum;
	import flash.utils.Dictionary;
	
	/**
	 * ...
	 * @author dorofiy.com
	 */
	public class IncrementEnum extends Enum
	{
		private static const DICTIONARY:Dictionary = new Dictionary();
		
		public function IncrementEnum()
		{
			super(getIndex());
		}
		
		private function getIndex():int
		{
			var type:Class = getType().type;
			var collection:int = DICTIONARY[type];
			collection++;
			DICTIONARY[type] = collection;
			return collection
		}
	}
}