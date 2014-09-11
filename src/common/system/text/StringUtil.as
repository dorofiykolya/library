package common.system.text
{
	import common.system.utils.BitFlagUtil;
	import common.system.utils.ObjectUtils;
	import flash.utils.Dictionary;
	
	/**
	 * ...
	 * @author dorofiy.com
	 */
	public class StringUtil
	{
		public static const EMPTY:String = "";
		
		public static function trim(text:String):String
		{
			var startIndex:int = 0;
			while (isWhitespace(text.charAt(startIndex)))
			{
				++startIndex;
			}
			var endIndex:int = text.length - 1;
			while (isWhitespace(text.charAt(endIndex)))
			{
				--endIndex;
			}
			if (endIndex >= startIndex)
			{
				return text.slice(startIndex, endIndex + 1);
			}
			return "";
		}
		
		public static function trimLeft(text:String):String
		{
			var startIndex:int = 0;
			while (isWhitespace(text.charAt(startIndex)))
			{
				++startIndex;
			}
			if (startIndex >= text.length)
			{
				return "";
			}
			return text.substring(startIndex, text.length);
		}
		
		public static function trimRight(text:String):String
		{
			var endIndex:int = text.length - 1;
			while (isWhitespace(text.charAt(endIndex)))
			{
				--endIndex;
			}
			if (endIndex <= 0)
			{
				return "";
			}
			return text.substring(0, endIndex + 1);
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
			}
			return false;
		}
		
		public static function replace(text:String, oldText:String, newText:String):String
		{
			return text.split(oldText).join(newText);
		}
		
		public static function replaceRegExp(text:String, oldText:String, newText:String, global:Boolean = false, caseSensitive:Boolean = false):String
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
			return text.replace(new RegExp(oldText, opt), newText);
		}
		
		public static function paddingLeft(text:String, maxWidth:int = 0, char:String = " "):String
		{
			if (text == null)
			{
				text = "";
			}
			if (maxWidth <= text.length)
			{
				return text;
			}
			//if (char.length > 1) char = char.charAt(0);
			var i:int = maxWidth - text.length;
			if (i <= 0)
			{
				return text;
			}
			while (i--)
			{
				text = char + text;
			}
			return text;
		}
		
		public static function paddingRight(text:String, maxWidth:int = 0, char:String = " "):String
		{
			if (text == null)
			{
				text = "";
			}
			if (maxWidth <= text.length)
			{
				return text;
			}
			//if (char.length > 1) char = char.charAt(0);
			var i:int = maxWidth - text.length;
			if (i <= 0)
			{
				return text;
			}
			while (i--)
			{
				text += char;
			}
			return text;
		}
		
		public static function contains(text:String, contains:String, caseSensitive:Boolean = false):Boolean
		{
			var i:int;
			if (caseSensitive == false)
			{
				i = text.toLowerCase().indexOf(contains.toLowerCase());
			}
			else
			{
				i = text.indexOf(contains);
			}
			return i != -1;
		}
		
		public static function insert(text:String, insertText:String, index:int = int.MAX_VALUE):String
		{
			if (index < 0)
			{
				index = 0;
			}
			if (index >= text.length)
			{
				text += insertText;
				return text;
			}
			var left:String = text.substring(0, index);
			var right:String = text.substring(index, text.length);
			return left + insertText + right;
		}
		
		public static function remove(text:String, removeExpression:String, global:Boolean = false, caseSensitive:Boolean = false):String
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
			return text.replace(new RegExp(removeExpression, opt), "");
		}
		
		public static function removeAt(text:String, removeExpression:String, index:int = 0, global:Boolean = false, caseSensitive:Boolean = false):String
		{
			var temp:String = text.substring(0, index);
			text = text.substring(index, text.length);
			text = remove(text, removeExpression, global, caseSensitive);
			return temp + text;
		}
		
		public static function removeCharsAt(text:String, index:int = 0, count:int = 0, insert:String = ""):String
		{
			if (count <= 0)
			{
				return text;
			}
			if (index < 0)
			{
				index = 0;
			}
			if (index == 0)
			{
				return insert + text.substring(count, text.length);
			}
			if (index > 0 && index + count >= text.length)
			{
				return text.substring(0, index) + insert;
			}
			var left:String;
			var right:String;
			left = text.substr(0, index);
			right = text.substring(index + count, text.length);
			return left + insert + right;
		}
		
		public static function removeAllWhitespaces(text:String):String
		{
			return text.replace(/[ \t\r\n\f]*/gi, "");
		}
		
		public static function removeLeftChars(text:String, count:int):String
		{
			if (count <= 0)
			{
				return text;
			}
			if (count >= text.length)
			{
				return EMPTY;
			}
			return text.substring(count, text.length);
		}
		
		public static function removeRightChars(text:String, count:int):String
		{
			if (count <= 0)
			{
				return text;
			}
			if (count >= text.length)
			{
				text = EMPTY;
				return text;
			}
			return text.substring(0, text.length - count);
		}
		
		public static function format(text:String, ... params):String
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
				//text = text.replace(new RegExp("\\{"+i+"\\}", "g"), args[i]);
				text = replace(text, "{" + i + "}", args[i]);
			}
			return text;
		}
		
		public static function wordWrap(string:String, width:int):String
		{
			var buffer:Array = [];
			var i:int = 0;
			var k:int = 0;
			var counter:int = 0;
			
			while (i < string.length)
			{
				for (counter = 1; counter <= width; counter++)
				{
					if (i == string.length)
					{
						return buffer.join("");
					}
					buffer[i] = string.charAt(i);
					if (buffer[i] == String.fromCharCode(13))
					{
						counter = 1;
					}
					i++;
				}
				if (isWhitespace(string.charAt(i)))
				{
					buffer[i] = String.fromCharCode(13);
					i++;
				}
				else
				{
					for (k = i; k > 0; k--)
					{
						if (isWhitespace(string.charAt(k)))
						{
							buffer[k] = String.fromCharCode(13);
							i = k + 1;
							break;
						}
					}
				}
			}
			return buffer.join("");
		}
		
//		public static function wrapText(text:String, maxWidth:uint = 100, delim:String = "\n"):String {
//			var lstLines:Vector.<String> = new Vector.<String>();
//			var spcCount:int = 0;
//			if(text != "" || text != null){
//				var Lines:Array /* of String */ = text.split(delim);
//				for (var j:int = 0; j < Lines.length; j++) 
//				{
//					var Line:String = Lines[j];
//					var Words:Array /* of String */ = Line.split(" ");
//					var curLine:String = "";
//					for each (var word:String in Words) 
//					{
//						spcCount = (curLine.length > 0? 1 : 0);
//						if(curLine.length + word.length + spcCount > maxWidth && curLine != ""){
//							lstLines.push(PadRight(curLine, maxWidth));
//							curLine = "";
//						}
//						if(word.length <= maxWidth){
//							if(curLine == ""){
//								curLine = word;
//							}else{
//								curLine += " " +word;
//							}
//						}else{
//							if(curLine != ""){
//								lstLines.push(PadRight(curLine, maxWidth));
//								curLine = "";
//							}
//							for (var i:int = 0; i < word.length; i++) 
//							{
//								if ( i + maxWidth < word.length) {
//									word = word.substring(i, maxWidth);
//									lstLines.push(word);
//								}else {
//									word = word.substring(i);
//									lstLines.push(PadRight(word, maxWidth));
//								}
//							}
//						}
//					}
//					if(curLine != ""){
//						lstLines.push(PadRight(curLine, maxWidth));
//					}
//				}
//			}
//			return lstLines.join(delim) as String;
//		}
		
		public static function padRight(txt:String, pad:uint):String
		{
			if (txt == null)
			{
				txt = "";
			}
			if (txt.length >= pad)
			{
				return txt;
			}
			var count:int = pad - txt.length;
			while (count--)
			{
				txt += " ";
			}
			return txt;
		}
		
		public static function padLeft(txt:String, pad:uint):String
		{
			if (txt == null)
			{
				txt = "";
			}
			if (txt.length >= pad)
			{
				return txt;
			}
			var temp:String = "";
			var count:int = pad - txt.length;
			while (count--)
			{
				temp += " ";
			}
			return temp + txt;
		}
		
		/**
		 * Perfomance for most lenght > 100.000
		 * @param	keys array(String), Vector.<String>
		 * @param	target
		 * @return index
		 */
		public static function binarySearch(keys:Object, target:String):int
		{
			var high:int = keys.length;
			var low:int = -1;
			while (high - low > 1)
			{
				var probe:int = (low + high) >> 1;
				if (keys[probe] > target)
				{
					high = probe;
				}
				else
				{
					low = probe;
				}
			}
			if (low == -1 || keys[low] !== target)
			{
				return -1;
			}
			return low;
		}
		
		public static function charIsNumber(char:String):Boolean
		{
			switch (char)
			{
				case "0": 
				case "1": 
				case "2": 
				case "3": 
				case "4": 
				case "5": 
				case "6": 
				case "7": 
				case "8": 
				case "9": 
					return true;
			}
			return false;
		}
		
		public static function charIsLatin(char:String):Boolean
		{
			return char >= "A" && char <= "Z" || char >= "a" && char <= "z";
		}
		
		public static function charIsCyrillic(char:String):Boolean
		{
			return char <= "я" && char >= "а" || char >= "А" && char <= "Я";
		}
		
		/**
		 * Returns time in hh:mm:ss format from seconds
		 *
		 * @param timeInSeconds <code>Time</code> in seconds to convert
		 *
		 * @return Formatted time string
		 */
		public static function formatTime(timeInSeconds:Number):String
		{
			var nRemainder:Number;
			
			var nHours:Number = timeInSeconds / (60 * 60);
			nRemainder = nHours - (nHours | 0);
			nHours = nHours | 0;
			
			var nMinutes:Number = nRemainder * 60;
			nRemainder = nMinutes - (nMinutes | 0);
			nMinutes = nMinutes | 0;
			
			var nSeconds:Number = nRemainder * 60;
			nRemainder = nSeconds - (nSeconds | 0);
			nSeconds = nSeconds | 0;
			
			var hString:String = nHours < 10 ? "0" + nHours : "" + nHours;
			var mString:String = nMinutes < 10 ? "0" + nMinutes : "" + nMinutes;
			var sString:String = nSeconds < 10 ? "0" + nSeconds : "" + nSeconds;
			
			if (timeInSeconds < 0 || isNaN(timeInSeconds))
			{
				return "00:00";
			}
			
			if (nHours > 0)
			{
				return hString + ":" + mString + ":" + sString;
			}
			return mString + ":" + sString;
		}
		
		/**
		 *
		 * @param	date (if (date == null) date = new Date())
		 * @param	format {HH}:{mm}:{ss}  example: {d}:{M}:{yyyy}-{HH}:{mm}:{ss}   27:09:2012-16:18:12
		 * {HH} - hourse 21, 01
		 * {H} - hourse 21, 1
		 * {mm} - minute 20, 02
		 * {m} - minute 20, 2
		 * {ss} - seconds 15, 05
		 * {s} - seconds 15, 5
		 * {ms} - milliseconds 105
		 * {d} - date 5
		 * {M} - month 3
		 * {yy} - year 10 (2010)
		 * {yyyy} - year 2010
		 * {time} - time in milliseconds from 01.01.1970
		 * {tz} - timezoneOffset +2, -2 (+2)
		 * A - 9 PM, 9 AM example 'HH A' - 9 AM
		 * @return format date
		 */
		public static function formatDate(date:Date = null, format:String = "{HH}:{mm}:{ss}"):String
		{
			if (date == null)
			{
				date = new Date();
			}
			
			function reformat(value:Number, ms:Boolean = false, skip:Boolean = false):String
			{
				if (skip)
				{
					return value.toString();
				}
				if (ms)
				{
					if (value <= 9)
						return "00" + value;
					if (value <= 99)
						return "0" + value;
					
					return value.toString();
				}
				if (value <= 9)
					return "0" + value;
				
				return value.toString();
			}
			var field:Object = {};
			field.HH = reformat(date.hours);
			field.H = reformat(date.hours, false, true);
			field.mm = reformat(date.minutes);
			field.m = reformat(date.minutes, false, true);
			field.ss = reformat(date.seconds);
			field.s = reformat(date.seconds, false, true);
			field.ms = reformat(date.milliseconds, true);
			field.d = reformat(date.date);
			field.M = reformat(date.month + 1);
			field.time = date.time.toString();
			field.yy = reformat(date.fullYear % 100);
			field.yyyy = date.fullYear.toString();
			field.tz = date.timezoneOffset > 0 ? "+" + date.timezoneOffset.toString() : date.timezoneOffset.toString();
			
			for (var key:String in field)
			{
				format = replace(format, "{" + key + "}", field[key]);
			}
			
			return format;
		}
		
		/**
		 * text = "Hello {m}{name}", object = {name:"Angy",m:"Ms."}
		 * example FormatFromObject("Date Now: {hours}", new Date());
		 * @param	text {key}
		 * @param	object
		 * @return
		 */
		public static function formatFrom(text:String, object:Object):String
		{
			if (isEmpty(text))
			{
				return "";
			}
			var dict:Object = ObjectUtils.getNamesOfMembers(object, ObjectUtils.FIELD_FLAG | ObjectUtils.PROPERTY_READ_FLAG | ObjectUtils.CONSTANT_FLAG | ObjectUtils.DYNAMIC_FLAG);
			for (var key:String in dict)
			{
				text = replace(text, "{" + key + "}", dict[key]);
			}
			return text;
		}
		
		/**
		 * Duplicates 'source' string 'count' times
		 *
		 * @param source <code>String</code> to duplicate
		 * @param count  Duplicates count
		 *
		 * @return Duplicated string
		 */
		public static function duplicateText(source:String, count:uint = 1):String
		{
			var res:String = '';
			while (count--)
			{
				res += source;
			}
			return res;
		}
		
		/**
		 * Converts HTML &amp;,&quot;,etc into the characters
		 *
		 * @param source HTML string to process
		 *
		 * @return <code>String</code> with unescaped HTML
		 */
		public static function unescapeHTML(source:String):String
		{
			return source.replace(/(&lt;)|(&gt;)|(&quot;)|(&amp;)|(&apos;)/gi, function():String { return new function():void{ this["&lt;"]="<", this["&gt;"]=">", this["&quot;"]="\"", this["&amp;"]="&", this["&apos;"]="'"; }()[arguments[0]] });
		}
		
		/**
		 * Encodes characters within a string for use in an HTML Text Field.
		 * The characters escaped include: &lt;&gt;'&#38;"
		 *
		 * @param source The <code>String</code> containing the HTML data
		 *
		 * @return An HTML encoded version of the original string
		 */
		public static function escapeHTML(source:String):String
		{
			var safeString:String = source;
			if (safeString.indexOf("&") >= 0)
			{
				safeString = safeString.split("&").join("&amp;");
			}
			if (safeString.indexOf("<") >= 0)
			{
				safeString = safeString.split("<").join("&lt;");
			}
			if (safeString.indexOf(">") >= 0)
			{
				safeString = safeString.split(">").join("&gt;");
			}
			if (safeString.indexOf("\"") >= 0)
			{
				safeString = safeString.split("\"").join("&quot;");
			}
			if (safeString.indexOf("'") >= 0)
			{
				safeString = safeString.split("'").join("&apos;");
			}
			return safeString;
		}
		
		public static function reverse(text:String):String
		{
			if (text == null)
			{
				return '';
			}
			return text.split('').reverse().join('');
		}
		
		public static function isEmpty(text:String, keepWhite:Boolean = false):Boolean
		{
			if (text == null)
				return true;
			if (text == EMPTY)
				return true;
			return isNotEmpty(text, keepWhite) == false;
		}
		
		public static function isNotEmpty(text:String, keepWhite:Boolean = false):Boolean
		{
			if (text == null)
				return false;
			if (text == EMPTY)
				return false;
			if (keepWhite == false)
			{
				text = text.split(" ").join("");
				text = text.split("\n").join("");
				text = text.split("\t").join("");
				text = text.split("\r").join("");
			}
			return text.length > 0;
		}
		
		public static function startsWith(text:String, starts:String):Boolean
		{
			if (text == null)
				return false;
			if (starts == null)
				return false;
			return text.indexOf(starts) == 0;
		}
		
		public static function endsWith(text:String, starts:String):Boolean
		{
			if (text == null)
				return false;
			if (starts == null)
				return false;
			if (text.length < starts.length)
				return false;
			return text.lastIndexOf(starts) == text.length - starts.length;
		}
		
		public static function split(text:String, delim:* = null, limit:uint = uint.MAX_VALUE, splitFlags:int = 0):Vector.<String>
		{
			if (text == null)
			{
				text = "";
			}
			var isNone:Boolean = splitFlags == SplitFlags.NONE;
			var isRemove:Boolean = BitFlagUtil.getFlag(splitFlags, SplitFlags.REMOVE_EMPTY);
			var isRemoveWithespace:Boolean = BitFlagUtil.getFlag(splitFlags, SplitFlags.REMOVE_WHITESPACE);
			var isTrim:Boolean = BitFlagUtil.getFlag(splitFlags, SplitFlags.TRIM);
			var array:Array = text.split(delim, limit);
			var result:Vector.<String> = new Vector.<String>(array.length);
			var length:int = array.length;
			var index:int;
			var current:String;
			for (var i:int = 0; i < length; i++)
			{
				current = array[i];
				if (isNone)
				{
					result[index] = current;
					index++;
					
					continue;
				}
				
				if (isRemove && current == EMPTY)
				{
					continue;
				}
				
				if (isRemoveWithespace && isEmpty(current))
				{
					continue;
				}
				
				if (isTrim)
				{
					current = trim(current);
				}
				
				result[index] = current;
				index++;
			}
			result.length = index;
			return result;
		}
		
		public static function getHash(text:String):uint
		{
			if (text == null) 
			{
				return 0;
			}
			var len:int = text.length;
			var h:uint = 0;
			for (var i:int = 0; i < len; i++) 
			{
				h = h * 129 + text.charCodeAt(i) + 0x9e370001;
			}
			return h;
		}
		
		public static function isBlank(value:String):Boolean
		{
			if (value == null) 
			{
				return true;
			}
			return trim(value).length == 0;
		}
		
		public static function isNotBlank(value:String):Boolean
		{
			return !isBlank(value);
		}
		
		public static function test(value:String, pattern:RegExp):Boolean
		{
			return value != null && pattern.test(value);
		}
		
		public static function isNumeric(value:String):Boolean
		{
			return test(value, /^[0-9]*$/);
		}
		
		public static function compareTo(text1:String, text2:String):int
		{
			if (text1 == null) 
			{
				text1 = "";
			}
			if (text2 == null) 
			{
				text2 = "";
			}
			return text1.localeCompare(text2);
		}
		
		public static function compareToIgnoreCase(str1:String, str2:String):int 
		{
			if (str1 == null) 
			{
				str1 = "";
			}
			if (str2 == null) 
			{
				str2 = "";
			}
			return compareTo(str1.toLowerCase(), str2.toLowerCase());
		}
		
		public static function isDigit(char:String):Boolean
		{
			if (char == null) 
			{
				return false;
			}
			var code:int = char.charCodeAt(0);
			return code >= 48 && code <= 57;
		}
	}
}