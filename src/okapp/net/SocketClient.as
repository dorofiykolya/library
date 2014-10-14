package okapp.net
{
    import common.system.ClassType;
    import common.system.IDisposable;
    import common.system.ITypeObject;
    import common.system.net.Socket;
    import common.system.Type;
    import flash.events.ErrorEvent;
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.events.IOErrorEvent;
    import flash.events.ProgressEvent;
    import flash.events.SecurityErrorEvent;
    import flash.system.Security;
    import flash.utils.ByteArray;
    import flash.utils.Endian;
    import okapp.events.PacketEvent;
    
    /**
     * ...
     * @author dorofiy.com
     */
    [Event(name="securityError",type="flash.events.SecurityErrorEvent")]
    [Event(name="socketData",type="flash.events.ProgressEvent")]
    [Event(name="ioError",type="flash.events.IOErrorEvent")]
    [Event(name="error",type="flash.events.ErrorEvent")]
    [Event(name="connect",type="flash.events.Event")]
    [Event(name="close",type="flash.events.Event")]
    [Event(name="packet",type="okapp.events.PacketEvent")]
    
    public class SocketClient extends EventDispatcher implements ITypeObject, IDisposable
    {
        //--------------------------------------------------------------------------
        //     
        //	PUBLIC CONSTANTS 
        //     
        //--------------------------------------------------------------------------
        
        public static const INSUFFICIENT_DATA_AVAILABLE_TO_READ:int = 1;
        public static const IS_NOT_VALID_COMPRESSED_DATA:int = 2;
        public static const SOCKET_IS_NOT_CONNECTED:int = 3;
        public static const SOCKET_HAS_BEEN_DISPOSED:int = 4;
        
        //--------------------------------------------------------------------------
        //     
        //	PRIVATE VARIABLES 
        //     
        //--------------------------------------------------------------------------
        
        private var _socket:Socket;
        private var _loadPolicyFile:Boolean;
        private var _sendByteArray:ByteArray;
        private var _byte:ByteArray;
        private var _buffer:ByteArray;
        private var _tempByte:ByteArray;
        private var _readByteLength:Boolean;
        private var _totalByte:uint;
        private var _endian:String;
        
        //----------------------------------
        //	CONSTRUCTOR
        //----------------------------------
        
        public function SocketClient(endian:String = null)
        {
            _socket = new Socket();
            _socket.addEventListener(ProgressEvent.SOCKET_DATA, socketDataHandler);
            _socket.addEventListener(Event.CLOSE, socketEventDelegateHandler);
            _socket.addEventListener(Event.CONNECT, socketEventDelegateHandler);
            _socket.addEventListener(IOErrorEvent.IO_ERROR, socketEventDelegateHandler);
            _socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, socketEventDelegateHandler);
            _socket.addEventListener(ProgressEvent.SOCKET_DATA, socketEventDelegateHandler);
            _loadPolicyFile = true;
            _readByteLength = true;
            _totalByte = 0;
            _sendByteArray = new ByteArray();
            _byte = new ByteArray();
            _buffer = new ByteArray();
            _tempByte = new ByteArray();
            
            if (endian == Endian.LITTLE_ENDIAN || endian == Endian.BIG_ENDIAN)
            {
                _endian = endian;
            }
            else
            {
                _endian = Endian.LITTLE_ENDIAN;
            }
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
        
        /* DELEGATE common.system.net.Socket */
        
        public function get host():String
        {
            return _socket.host;
        }
        
        public function get port():int
        {
            return _socket.port;
        }
        
        public function get timeout():uint
        {
            return _socket.timeout;
        }
        
        public function set timeout(value:uint):void
        {
            _socket.timeout = value;
        }
        
        public function get connected():Boolean
        {
            return _socket.connected;
        }
        
        //--------------------------------------------------------------------------
        //     
        //	PUBLIC METHODS 
        //     
        //--------------------------------------------------------------------------
        
        public function send(data:ByteArray):void
        {
            if (_socket == null)
            {
                dispatchEvent(new ErrorEvent(ErrorEvent.ERROR, false, false, "The socket has been disposed", SOCKET_HAS_BEEN_DISPOSED));
                return;
            }
            if (_socket.connected == false)
            {
                dispatchEvent(new ErrorEvent(ErrorEvent.ERROR, false, false, "The socket is not connected", SOCKET_IS_NOT_CONNECTED));
                return;
            }
            _socket.writeBytes(data, data.position, data.bytesAvailable);
            _socket.flush();
        }
        
        /* INTERFACE common.system.IDisposable */
        
        public function dispose():void
        {
            if (_socket)
            {
                if (_socket.connected)
                {
                    _socket.close();
                }
                _socket.removeEventListener(ProgressEvent.SOCKET_DATA, socketDataHandler);
                _socket.removeEventListener(Event.CLOSE, socketEventDelegateHandler);
                _socket.removeEventListener(Event.CONNECT, socketEventDelegateHandler);
                _socket.removeEventListener(IOErrorEvent.IO_ERROR, socketEventDelegateHandler);
                _socket.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, socketEventDelegateHandler);
                _socket.removeEventListener(ProgressEvent.SOCKET_DATA, socketEventDelegateHandler);
                clearData();
                _socket = null;
                _sendByteArray = null;
                _byte = null
                _buffer = null;
                _tempByte = null;
            }
        }
        
        /* DELEGATE common.system.net.Socket */
        
        public function connect(host:String, port:int):void
        {
            clearData();
            if (_loadPolicyFile)
            {
                Security.loadPolicyFile("xmlsocket://" + host + ":" + port);
            }
            _socket.connect(host, port);
        }
        
        public function reconnect():void
        {
            clearData();
            _socket.reconnect();
        }
        
        public function close():void
        {
            clearData();
            _socket.close();
        }
        
        /* INTERFACE common.system.ITypeObject */
        
        public function getType():Type
        {
            return ClassType.getType(this);
        }
        
        //--------------------------------------------------------------------------
        //     
        //	PRIVATE METHODS 
        //     
        //--------------------------------------------------------------------------
        
        private function socketEventDelegateHandler(event:Event):void
        {
            dispatchEvent(event);
        }
        
        private function clearData():void
        {
            _sendByteArray.clear();
            _byte.clear();
            _buffer.clear();
            _tempByte.clear();
        }
        
        private function socketDataHandler(event:ProgressEvent):void
        {
            _byte.clear();
            _byte.position = 0;
            _byte.endian = _endian;
            if (_tempByte.length > 0)
            {
                _tempByte.endian = _endian;
                _byte.writeBytes(_tempByte, 0, _tempByte.length);
                _tempByte.clear();
            }
            _socket.readBytes(_byte, _byte.position, _socket.bytesAvailable);
            _byte.endian = _endian;
            _byte.position = 0;
            
            while (_byte.bytesAvailable)
            {
                if (_readByteLength)
                {
                    if (_byte.bytesAvailable < 4)
                    {
                        _tempByte.writeBytes(_byte, _byte.position, _byte.bytesAvailable);
                        return;
                    }
                    try
                    {
                        _socket.endian = _endian;
                        _totalByte = _socket.readUnsignedInt();
                    }
                    catch (e:Error)
                    {
                        dispatchEvent(new IOErrorEvent(IOErrorEvent.IO_ERROR, false, false, "There is insufficient data available to read.", INSUFFICIENT_DATA_AVAILABLE_TO_READ));
                        return;
                    }
                    _readByteLength = false;
                }
                if (_byte.bytesAvailable == 0)
                {
                    continue;
                }
                var currentByte:int = _byte.readByte();
                _buffer.writeByte(currentByte);
                _totalByte--;
                if (_totalByte == 0)
                {
                    _buffer.position = 0;
                    try
                    {
                        _buffer.uncompress();
                    }
                    catch (e:Error)
                    {
                        dispatchEvent(new IOErrorEvent(IOErrorEvent.IO_ERROR, false, false, "The data is not valid compressed data; it was not compressed with the same compression algorithm used to compress.", IS_NOT_VALID_COMPRESSED_DATA));
                        
                        _buffer.clear();
                        _readByteLength = true;
                        continue;
                    }
                    _buffer.position = 0;
                    
                    var packetBytes:ByteArray = new ByteArray();
                    packetBytes.writeBytes(_buffer, 0, _buffer.length);
                    dispatchEvent(new PacketEvent(PacketEvent.PACKET, packetBytes));
                    
                    _buffer.position = 0;
                    _buffer.clear();
                    _readByteLength = true;
                }
            }
        }
    }
}