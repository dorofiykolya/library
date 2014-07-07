package common.system.keyboard
{
	import common.system.ClassType;
	import common.system.dispatchers.ListenerMap;
	import common.system.IDisposable;
	import common.system.IEquatable;
	import common.system.TypeObject;
	import common.system.utils.formatString;
	import flash.display.Stage;
	import flash.events.KeyboardEvent;
	
	/**
	 * ...
	 * @author dorofiy.com
	 */
	public class CharController extends TypeObject implements IDisposable, IEquatable
	{
		//--------------------------------------------------------------------------
		//     
		//	PRIVATE VARIABLES 
		//     
		//--------------------------------------------------------------------------
		
		private var _stage:Stage;
		private var _eventDispather:ListenerMap;
		private var _enabled:Boolean;
		private var _ctrl:Boolean;
		private var _alt:Boolean;
		private var _shift:Boolean;
		private var _up:Boolean;
		private var _char:String;
		private var _keyCode:uint;
		
		//----------------------------------
		//	CONSTRUCTOR
		//----------------------------------
		
		public function CharController(stage:Stage)
		{
			if (stage == null)
			{
				throw new ArgumentError(ClassType.getQualifiedClassName(this) + ", ArgumentError, stage can not be null");
			}
			_stage = stage;
			_enabled = true;
			_eventDispather = new ListenerMap();
			_stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
			_stage.addEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
		}
		
		//--------------------------------------------------------------------------
		//     
		//	PUBLIC METHODS 
		//     
		//--------------------------------------------------------------------------
		
		public function add(charOrKeyCode:Object, keyboardEventListener:Function, ctrlKey:Boolean = false, altKey:Boolean = false, shiftKey:Boolean = false, keyUp:Boolean = true):void
		{
			if (charOrKeyCode == null || charOrKeyCode === 0 || charOrKeyCode is String && charOrKeyCode.length != 1)
			{
				throw new ArgumentError(ClassType.getQualifiedClassName(this));
			}
			
			var key:String = formatString("(charOrKeyCode:{0}, ctrlKey:{1}, altKey:{2}, shiftKey:{3}, keyUp:{4})", String(charOrKeyCode).toLowerCase(), ctrlKey, altKey, shiftKey, keyUp);
			_eventDispather.add(key, keyboardEventListener);
		}
		
		public function remove(charOrKeyCode:Object, keyboardEventListener:Function, ctrlKey:Boolean = false, altKey:Boolean = false, shiftKey:Boolean = false, keyUp:Boolean = true):void
		{
			if (charOrKeyCode == null || charOrKeyCode === 0 || charOrKeyCode is String && charOrKeyCode.length != 1)
			{
				throw new ArgumentError(ClassType.getQualifiedClassName(this));
			}
			var key:String = formatString("(charOrKeyCode:{0}, ctrlKey:{1}, altKey:{2}, shiftKey:{3}, keyUp:{4})", String(charOrKeyCode).toLowerCase(), ctrlKey, altKey, shiftKey, keyUp);
			_eventDispather.remove(key, keyboardEventListener);
		}
		
		public function has(charOrKeyCode:Object, ctrlKey:Boolean = false, altKey:Boolean = false, shiftKey:Boolean = false, keyUp:Boolean = true):Boolean
		{
			if (charOrKeyCode == null || charOrKeyCode === 0 || charOrKeyCode is String && charOrKeyCode.length != 1)
			{
				throw new ArgumentError(ClassType.getQualifiedClassName(this));
			}
			var key:String = formatString("(charOrKeyCode:{0}, ctrlKey:{1}, altKey:{2}, shiftKey:{3}, keyUp:{4})", String(charOrKeyCode).toLowerCase(), ctrlKey, altKey, shiftKey, keyUp);
			return _eventDispather.has(key);
		}
		
		public function get enabled():Boolean
		{
			return _enabled;
		}
		
		public function set enabled(value:Boolean):void
		{
			_enabled = value;
		}
		
		/* INTERFACE common.system.IEquatable */
		
		public function equals(value:Object):Boolean
		{
			return this == value;
		}
		
		/* INTERFACE common.system.IDisposable */
		
		public function dispose():void
		{
			if (_eventDispather)
			{
				_eventDispather.dispose();
				_eventDispather = null;
			}
			
			if (_stage)
			{
				_stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
				_stage.removeEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
				_stage = null;
			}
		}
		
		//--------------------------------------------------------------------------
		//     
		//	PRIVATE METHODS 
		//     
		//--------------------------------------------------------------------------
		
		private function keyUpHandler(event:KeyboardEvent):void
		{
			_ctrl = event.ctrlKey;
			_shift = event.shiftKey;
			_alt = event.altKey;
			_up = false;
			_char = String.fromCharCode(event.charCode);
			_keyCode = event.keyCode;
			process(event);
		}
		
		private function keyDownHandler(event:KeyboardEvent):void
		{
			_ctrl = event.ctrlKey;
			_shift = event.shiftKey;
			_alt = event.altKey;
			_up = true;
			_char = String.fromCharCode(event.charCode);
			_keyCode = event.keyCode;
			process(event);
		}
		
		private function process(event:KeyboardEvent):void
		{
			if (!_enabled)
			{
				return;
			}
			
			var key:String = formatString("(charOrKeyCode:{0}, ctrlKey:{1}, altKey:{2}, shiftKey:{3}, keyUp:{4})", _char.toLowerCase(), _ctrl, _alt, _shift, _up);
			var keyCode:String = formatString("(charOrKeyCode:{0}, ctrlKey:{1}, altKey:{2}, shiftKey:{3}, keyUp:{4})", _keyCode, _ctrl, _alt, _shift, _up);
			
			if (_eventDispather.has(key))
			{
				_eventDispather.invoke(key, event);
			}
			if (_eventDispather.has(keyCode))
			{
				_eventDispather.invoke(keyCode, event);
			}
		}
	}
}