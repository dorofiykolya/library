package common.system.net
{
	import common.system.ClassType;
	import common.system.IDisposable;
	import common.system.ITypeObject;
	import common.system.Type;
	import flash.net.Socket;
	import flash.system.Security;
	
	/**
	 * ...
	 * @author dorofiy.com
	 */
	public class Socket extends flash.net.Socket implements ITypeObject, IDisposable
	{
		//--------------------------------------------------------------------------
		//     
		//	PRIVATE VARIABLES 
		//     
		//--------------------------------------------------------------------------
		
		private var _host:String;
		private var _port:int;
		private var _loadPolicyFile:Boolean;
		
		//----------------------------------
		//	CONSTRUCTOR
		//----------------------------------
		
		public function Socket(host:String = null, port:int = 0)
		{
			super(host, port);
			_host = host;
			_port = port;
		}
		
		//--------------------------------------------------------------------------
		//     
		//	PUBLIC PROPERTIES 
		//     
		//--------------------------------------------------------------------------
		
		public function get loadPolicyFile():Boolean
		{
			return _loadPolicyFile;
		}
		
		public function set loadPolicyFile(value:Boolean):void
		{
			_loadPolicyFile = value;
		}
		
		public function get host():String
		{
			return _host;
		}
		
		public function get port():int
		{
			return _port;
		}
		
		//--------------------------------------------------------------------------
		//     
		//	PUBLIC METHODS 
		//     
		//--------------------------------------------------------------------------
		
		override public function connect(host:String, port:int):void
		{
			_host = host;
			_port = port;
			if (_loadPolicyFile)
			{
				Security.loadPolicyFile("xmlsocket://" + host + ":" + port);
			}
			super.connect(host, port);
		}
		
		public function reconnect():void
		{
			if (connected)
			{
				close();
			}
			connect(_host, _port);
		}
		
		/* INTERFACE common.system.ITypeObject */
		
		public function getType():Type
		{
			return ClassType.getType(this);
		}
		
		/* INTERFACE common.system.IDisposable */
		
		public function dispose():void
		{
			if (connected)
			{
				close();
			}
		}
	}
}