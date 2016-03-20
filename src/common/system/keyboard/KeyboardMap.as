package common.system.keyboard
{
	import common.system.ClassType;
	import common.system.TypeObject;
	import flash.display.Stage;
	import flash.events.EventDispatcher;
	import flash.events.KeyboardEvent;
	import flash.utils.Dictionary;
	
	/**
	 * ...
	 * @author dorofiy.com
	 */
	public class KeyboardMap extends TypeObject
	{
		private var _map:Dictionary;
		private var _stage:Stage;
		
		public function KeyboardMap(stage:Stage)
		{
			if (stage == null)
			{
				throw new ArgumentError(ClassType.getQualifiedClassName(this) + ", ArgumentError, stage can not be null");
			}
			_stage = stage;
			_map = new Dictionary();
			_stage.addEventListener(KeyboardEvent.KEY_DOWN, keyHandler);
			_stage.addEventListener(KeyboardEvent.KEY_UP, keyHandler);
		}
		
		public function map(charOrKeyCode:Object, ctrlKey:Boolean = false, altKey:Boolean = false, shiftKey:Boolean = false):EventDispatcher
		{
			if (charOrKeyCode == null || charOrKeyCode === 0 || charOrKeyCode is String && charOrKeyCode.length != 1)
			{
				throw new ArgumentError(ClassType.getQualifiedClassName(this) + ", argument error");
			}
			
			var key:String = getKey(charOrKeyCode, ctrlKey, altKey, shiftKey);
			var eventDispather:EventDispatcher = _map[key];
			if (eventDispather == null)
			{
				eventDispather = new EventDispatcher();
				_map[key] = eventDispather;
			}
			return eventDispather;
		}
		
		private function keyHandler(event:KeyboardEvent):void
		{
			var keyChar:String = getKey(String.fromCharCode(event.charCode), event.ctrlKey, event.altKey, event.shiftKey);
			var keyCode:String = getKey(event.keyCode, event.ctrlKey, event.altKey, event.shiftKey);
			var eventDispather:EventDispatcher = _map[keyChar];
			if (eventDispather != null)
			{
				eventDispather.dispatchEvent(event);
			}
			eventDispather = _map[keyCode]
			if (eventDispather != null)
			{
				eventDispather.dispatchEvent(event);
			}
		}
		
		private function getKey(charOrKeyCode:Object, ctrlKey:Boolean = false, altKey:Boolean = false, shiftKey:Boolean = false):String
		{
			var bitField:uint = 0;
				bitField |= 1;
			if (ctrlKey)
				bitField |= 1 << 2;
			if (altKey)
				bitField |= 1 << 3;
			if (shiftKey)
				bitField |= 1 << 4;
			return bitField.toString(16) + ":" + String(charOrKeyCode);
		}
	
	}

}