package common.system.application.controllers
{
	import common.system.ClassType;
	import common.system.IDisposable;
	import common.system.TypeObject;
	import flash.display.Stage;
	import flash.display.StageDisplayState;
	
	/**
	 * ...
	 * @author dorofiy.com
	 */
	public class DisplayStateController extends TypeObject implements IDisposable
	{
		private var _stage:Stage;
		
		public function DisplayStateController(stage:Stage)
		{
			if (stage == null)
			{
				throw new ArgumentError(ClassType.getQualifiedClassName(this) + ", argument can not be null");
			}
			_stage = stage;
			_stage.displayState = StageDisplayState.FULL_SCREEN
			_stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE
			_stage.displayState = StageDisplayState.NORMAL
		}
		
		public function get current():String
		{
			return _stage.displayState;
		}
		
		public function set current(value:String):void
		{
			_stage.displayState = value;
		}
		
		public function normal():void
		{
			_stage.displayState = "normal";
		}
		
		public function fullScreen():Boolean
		{
			_stage.displayState == "fullScreen";
		}
		
		public function fullScreenInteractive():Boolean
		{
			if ("fullScreenInteractive" in StageDisplayState)
			{
				_stage.displayState == "fullScreenInteractive";
			}
			else
			{
				fullScreen();
			}
		}
		
		public function get isNormanl():Boolean
		{
			return _stage.displayState == "normal";
		}
		
		public function get isFullScreen():Boolean
		{
			return _stage.displayState == "fullScreen";
		}
		
		public function get isFullScreenInteractive():Boolean
		{
			return _stage.displayState == "fullScreenInteractive";
		}
		
		/* INTERFACE common.system.IDisposable */
		
		public function dispose():void
		{
			_stage = null;
		}
	}
}