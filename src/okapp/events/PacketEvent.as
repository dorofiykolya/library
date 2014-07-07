package okapp.events
{
	import common.system.ClassType;
	import common.system.ITypeObject;
	import common.system.Type;
	import flash.events.Event;
	import flash.utils.ByteArray;
	
	/**
	 * ...
	 * @author dorofiy.com
	 */
	public class PacketEvent extends Event implements ITypeObject
	{
		//--------------------------------------------------------------------------
		//     
		//	PUBLIC CONSTANTS 
		//     
		//--------------------------------------------------------------------------
		
		public static const PACKET:String = "packet";
		
		//--------------------------------------------------------------------------
		//     
		//	PUBLIC VARIABLES 
		//     
		//--------------------------------------------------------------------------
		
		public var data:ByteArray;
		
		//----------------------------------
		//	CONSTRUCTOR
		//----------------------------------
		
		public function PacketEvent(type:String, data:ByteArray = null)
		{
			super(type);
			this.data = data;
		}
		
		//--------------------------------------------------------------------------
		//     
		//	PUBLIC METHODS 
		//     
		//--------------------------------------------------------------------------
		
		override public function clone():Event
		{
			var event:PacketEvent = new PacketEvent(type);
			event.data = data;
			return event;
		}
		
		/* INTERFACE common.system.ITypeObject */
		
		public function getType():Type
		{
			return ClassType.getType(this);
		}
	}
}