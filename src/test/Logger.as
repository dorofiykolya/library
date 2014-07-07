package test 
{
	import common.system.application.Application;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	
	/**
	 * ...
	 * @author dorofiy.com
	 */
	public class Logger extends Sprite 
	{
		private static var _instance:Logger;
		private var _textField:TextField;
		
		public function Logger() 
		{
			_textField = new TextField();
			_textField.autoSize = TextFieldAutoSize.LEFT;
			_textField.background = true;
			_textField.border = true;
			_textField.backgroundColor = 0;
			_textField.textColor = 0xffffff;
			addChild(_textField);
		}
		
		static public function log(...args):void 
		{
			if (_instance == null)
			{
				_instance = new Logger();
			}
			for each (var item:Object in args) 
			{
				_instance._textField.appendText(String(item));
				_instance._textField.appendText("\n");
			}
			if (_instance.parent == null && Application.stage)
			{
				Application.stage.addChild(_instance);
			}
		}
		
	}

}