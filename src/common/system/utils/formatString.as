package common.system.utils
{
	/**
	 * ...
	 * @author dorofiy.com
	 */
	
	/**
	 * .Net
	 * Formats with curly braces ("{0}"). 
	 * format string
	 * @param	text
	 * @param	... params array (if params length == 1 && params[0] is Array ===>>  params = params[0])
	 * @return result text;
	 */
	public function formatString(text:String, ... params):String
	{
		var len:uint = params.length;
		var args:Array;
		if (len == 1 && params[0] is Array)
		{
			args = params[0];
			len = args.length;
		}
		else
		{
			args = params;
		}
		
		for (var i:int = 0; i < len; i++)
		{
			text = text.split("{" + i + "}").join(args[i]);
		}
		return text;
	}

}