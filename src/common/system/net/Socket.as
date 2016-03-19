package common.system.net
{
	import common.system.ClassType;
	import common.system.IDisposable;
	import common.system.ITypeObject;
	import common.system.Type;
	import flash.events.Event;
	import flash.events.ProgressEvent;
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
		private var _processPolicy:Boolean;
		private var _policyReceived:Boolean;
		
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
		
		public function get processPolicy():Boolean
		{
			return _processPolicy;
		}
		
		public function set processPolicy(value:Boolean):void
		{
			_processPolicy = value;
		}
		
		public function get policyReceived():Boolean
		{
			return _policyReceived;
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
			
			if (_processPolicy)
			{
				_policyReceived = false;
				removeEventListener(ProgressEvent.SOCKET_DATA, onSocketDataHandler);
				addEventListener(Event.CONNECT, onConnectHandler, false, int.MAX_VALUE);
			}
			
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
		
		//--------------------------------------------------------------------------
		//     
		//	PRIVATE METHODS 
		//     
		//--------------------------------------------------------------------------
		
		private function onConnectHandler(e:Event):void
		{
			if (_processPolicy)
			{
				_policyReceived = false;
				
				addEventListener(ProgressEvent.SOCKET_DATA, onSocketDataHandler, false, int.MAX_VALUE);
				removeEventListener(Event.CONNECT, onConnectHandler);
				
				writeUTFBytes("<policy-file-request />");
				writeByte(0);
				flush();
				
				e.stopImmediatePropagation();
			}
		}
		
		private function onSocketDataHandler(e:ProgressEvent):void
		{
			while (bytesAvailable != 0)
			{
				var byte:int = readByte();
				if (byte == 0)
				{
					_policyReceived = true;
					
					removeEventListener(ProgressEvent.SOCKET_DATA, onSocketDataHandler);
					addEventListener(Event.CLOSE, onCloseHandler, false, int.MAX_VALUE);
					close();
					removeEventListener(Event.CLOSE, onCloseHandler);
					super.connect(_host, _port);
					return;
				}
			}
			e.stopImmediatePropagation();
		}
		
		private function onCloseHandler(e:Event):void 
		{
			e.stopImmediatePropagation();
		}
	}
}