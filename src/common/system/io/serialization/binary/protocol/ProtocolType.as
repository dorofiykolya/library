package common.system.io.serialization.binary.protocol
{
	import common.system.TypeObject;
	
	/**
	 * ...
	 * @author dorofiy.com
	 */
	public class ProtocolType extends TypeObject
	{
		//--------------------------------------------------------------------------
		//     
		//	PUBLIC VARIABLES 
		//     
		//--------------------------------------------------------------------------
		
		public var name:String;
		public var type:Class;
		public var itemType:Class;
		public var metaType:Class;
		public var members:Vector.<ProtocolType>;
		
		//----------------------------------
		//	CONSTRUCTOR
		//----------------------------------
		
		public function ProtocolType()
		{
		
		}
		
		//--------------------------------------------------------------------------
		//     
		//	INTERNAL METHODS 
		//     
		//--------------------------------------------------------------------------
		
		internal function asMember(name:String, memberItem:Class, memberMeta:Class):ProtocolType
		{
			var p:ProtocolType = new ProtocolType();
			p.name = name;
			p.type = type;
			p.itemType = memberItem;
			p.metaType = memberMeta;
			p.members = members;
			return p;
		}
	}
}