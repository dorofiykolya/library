package common.system.text
{
	import common.system.IDisposable;
	import common.system.IEquatable;
	
	/**
	 * ...
	 * @author dorofiy.com
	 */
	public class StringBuilder implements IEquatable, IDisposable
	{
		public static const EMPTY:String = "";
		
		private var _string:String;
		
		public function StringBuilder(string:String = "", ... format)
		{
			if (string == null)
			{
				string = "";
			}
			this._string = string;
			
			if (format.length > 0)
			{
				format.apply(null, format);
			}
		}
		
		public function dispose():void
		{
			_string = null;
		}
		
		public function append(text:String):void
		{
			_string += text;
		}
		
		public function appendLine(text:String):void
		{
			_string += text + "\n";
		}
		
		public function appendFormat(text:String, ... params):void
		{
			var len:uint = params.length;
			var args:Array;
			if (len == 1 && params[0] is Array)
			{
				args = params[0] as Array;
				len = args.length;
			}
			else
			{
				args = params;
			}
			
			for (var i:int = 0; i < len; i++)
			{
				text = text.replace(new RegExp("\\{" + i + "\\}", "g"), args[i]);
			}
			_string += text;
		}
		
		public function appendEndLine():void
		{
			_string += "\n";
		}
		
		public function clear():void
		{
			_string = "";
		}
		
		public function equals(value:Object):Boolean
		{
			return _string == String(value);
		}
		
		public function appendAt(text:String, index:int = int.MAX_VALUE):void
		{
			if (index < 0)
			{
				index = 0;
			}
			if (index >= _string.length)
			{
				_string += text;
				return;
			}
			var left:String = _string.substring(0, index);
			var right:String = _string.substring(index, _string.length);
			_string = left + text + right;
		}
		
		public function insert(text:String, index:int = int.MAX_VALUE):void
		{
			if (index < 0)
			{
				index = 0;
			}
			if (index >= _string.length)
			{
				_string += text;
				return;
			}
			var left:String = _string.substring(0, index);
			var right:String = _string.substring(index, _string.length);
			_string = left + text + right;
		}
		
		public function contains(text:String, caseSensitive:Boolean = false):Boolean
		{
			var i:int;
			if (caseSensitive == false)
			{
				i = _string.toLowerCase().indexOf(text.toLowerCase());
			}
			else
			{
				i = _string.indexOf(text);
			}
			return i != -1;
		}
		
		public function search(text:String, startIndex:int = int.MAX_VALUE, caseSensitive:Boolean = false):int
		{
			if (caseSensitive == false)
			{
				return _string.toLowerCase().indexOf(text.toLowerCase(), startIndex);
			}
			return _string.indexOf(text, startIndex);
		}
		
		public function searchLast(text:String, index:int = int.MAX_VALUE, caseSensitive:Boolean = false):int
		{
			if (caseSensitive == false)
			{
				return _string.toLowerCase().lastIndexOf(text.toLowerCase(), index);
			}
			return _string.lastIndexOf(text, index);
		}
		
		public function remove(text:String, global:Boolean = false, caseSensitive:Boolean = false):Boolean
		{
			var opt:String = '';
			if (global)
			{
				opt += "g";
			}
			if (caseSensitive == false)
			{
				opt += "i";
			}
			var i:int;
			if (caseSensitive == false)
			{
				i = _string.toLowerCase().indexOf(text.toLowerCase());
			}
			else
			{
				i = _string.indexOf(text);
			}
			_string = _string.replace(new RegExp(text, opt), "");
			return i != -1;
		}
		
		public function removeAt(text:String, index:int = 0, global:Boolean = false, caseSensitive:Boolean = false):Boolean
		{
			var str:String = _string;
			var txt:String = text;
			if (caseSensitive == false)
			{
				str = str.toLowerCase();
				txt = txt.toLowerCase();
			}
			var i:int = str.indexOf(txt, index);
			if (i != -1)
			{
				var left:String = _string.substring(0, i);
				var right:String = _string.substring(i + 1, _string.length);
				_string = left + right;
			}
			if (global && i != -1)
			{
				while (removeAt(text, index, global, caseSensitive));
			}
			return i != -1;
		}
		
		public function removeLeftChars(count:int):void
		{
			if (count <= 0)
			{
				return;
			}
			if (count >= _string.length)
			{
				_string = EMPTY;
				return;
			}
			_string = _string.substring(count, _string.length);
		}
		
		public function removeRightChars(count:int):void
		{
			if (count <= 0)
			{
				return;
			}
			if (count >= _string.length)
			{
				_string = EMPTY;
				return;
			}
			_string = _string.substring(0, _string.length - count);
		}
		
		public function removeRange(startIndex:int = 0, endIndex:int = int.MAX_VALUE):void
		{
			_string = _string.substring(startIndex, endIndex);
		}
		
		public function removeCount(startIndex:int, count:int = int.MAX_VALUE):void
		{
			_string = _string.substr(startIndex, count);
		}
		
		public function removeAllWhitespaces():void
		{
			_string = _string.replace(/[ \t\r\n\f]*/gi, "");
		}
		
		public function format(... params):void
		{
			var len:uint = params.length;
			var args:Array;
			if (len == 1 && params[0] is Array)
			{
				args = params[0] as Array;
				len = args.length;
			}
			else
			{
				args = params;
			}
			
			for (var i:int = 0; i < len; i++)
			{
				_string = _string.replace(new RegExp("\\{" + i + "\\}", "g"), args[i]);
			}
		}
		
		public function parameters(... params):void
		{
			var len:uint = params.length;
			var args:Array;
			if (len == 1 && params[0] is Array)
			{
				args = params[0] as Array;
				len = args.length;
			}
			else
			{
				args = params;
			}
			
			for (var i:int = 0; i < len; i++)
			{
				_string = _string.replace(new RegExp("\\{" + i + "\\}", "g"), args[i]);
			}
		}
		
		public function replaceRegExp(oldText:String, newText:String, global:Boolean = false, caseSensitive:Boolean = false):Boolean
		{
			var opt:String = '';
			if (global)
			{
				opt += "g";
			}
			if (caseSensitive == false)
			{
				opt += "i";
			}
			var i:int;
			if (caseSensitive == false)
			{
				i = _string.toLowerCase().indexOf(oldText.toLowerCase());
			}
			else
			{
				i = _string.indexOf(oldText);
			}
			_string = _string.replace(new RegExp(oldText, opt), newText);
			return i != -1;
		}
		
		public function replace(oldText:String, newText:String):void
		{
			_string = _string.split(oldText).join(newText);
		}
		
		public function trim():void
		{
			var startIndex:int = 0;
			while (isWhitespace(_string.charAt(startIndex)))
			{
				++startIndex;
			}
			
			var endIndex:int = _string.length - 1;
			while (isWhitespace(_string.charAt(endIndex)))
			{
				--endIndex;
			}
			
			if (endIndex >= startIndex)
			{
				_string = _string.slice(startIndex, endIndex + 1);
			}
			else
			{
				_string = "";
			}
		}
		
		public function trimLeft():void
		{
			var startIndex:int = 0;
			while (isWhitespace(_string.charAt(startIndex)))
			{
				++startIndex;
			}
			if (startIndex >= _string.length)
			{
				_string = "";
			}
			else
			{
				_string = _string.substring(startIndex, _string.length);
			}
		}
		
		public function trimRight():void
		{
			var endIndex:int = _string.length - 1;
			while (isWhitespace(_string.charAt(endIndex)))
			{
				--endIndex;
			}
			if (endIndex <= 0)
			{
				_string = "";
			}
			else
			{
				_string = _string.substring(0, endIndex + 1);
			}
		}
		
		public function paddingLeft(maxWidth:int = 0, char:String = " "):void
		{
			if (maxWidth <= _string.length)
			{
				return;
			}
			if (char.length > 1)
			{
				char = char.charAt(0);
			}
			var i:int = maxWidth - _string.length;
			if (i <= 0)
			{
				return;
			}
			while (i--)
			{
				_string = char + _string;
			}
		}
		
		public function paddingRight(maxWidth:int = 0, char:String = " "):void
		{
			if (maxWidth <= _string.length)
			{
				return;
			}
			if (char.length > 1)
			{
				char = char.charAt(0);
			}
			var i:int = maxWidth - _string.length;
			if (i <= 0)
			{
				return;
			}
			while (i--)
			{
				_string += char;
			}
		}
		
		public function toUpperCase():void
		{
			_string = _string.toUpperCase();
		}
		
		public function toLowerCase():void
		{
			_string = _string.toLowerCase();
		}
		
		public function get lenght():int
		{
			return _string.length;
		}
		
		public function set lenght(value:int):void
		{
			if (value <= 0)
			{
				value = 0;
			}
			if (value == 0)
			{
				_string = "";
				return;
			}
			if (value >= _string.length)
			{
				value = _string.length;
			}
			_string = _string.substring(0, value);
		}
		
		public function toString():String
		{
			return _string;
		}
		
		public function get text():String
		{
			return _string;
		}
		
		public function set text(value:String):void
		{
			if (value == null)
			{
				value = EMPTY;
			}
			_string = value;
		}
		
		public function get isEmpty():Boolean
		{
			return _string == "";
		}
		
		public static function isWhitespace(character:String):Boolean
		{
			switch (character)
			{
				case " ": 
				case "\t": 
				case "\r": 
				case "\n": 
				case "\f": 
					return true;
				
				default: 
					return false;
			}
		}
	}
}