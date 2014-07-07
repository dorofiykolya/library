package common.system.application
{
	import common.system.application.controllers.DisplayStateController;
	import common.system.application.controllers.QualityController;
	import common.system.ClassType;
	import common.system.Environment;
	import common.system.ITypeObject;
	import common.system.Type;
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.system.Security;
	
	/**
	 * ...
	 * @author dorofiy.com
	 */
	
	[Event(name="complete",type="flash.events.Event")]
	
	public dynamic class Application extends MovieClip implements ITypeObject
	{
		private static var _stage:Stage;
		private static var _active:Boolean;
		private static var _parameters:Object;
		private static var _instance:Application;
		
		private var _loadCompleted:Boolean;
		private var _startTime:Number;
		
		public function Application(allowDomain:String = "*", allowInsecureDomain:String = "*")
		{
			if (!Environment.isDesktop)
			{
				if ("allowDomain" in Security)
				{
					Security["allowDomain"](allowDomain);
				}
				if ("allowInsecureDomain" in Security)
				{
					Security["allowInsecureDomain"](allowInsecureDomain);
				}
			}
			
			_active = Environment.isIOS || Environment.isIphone || Environment.isIpad;
			_startTime = new Date().time;
			_instance = this;
			
			addEventListener(Event.ACTIVATE, activeHandler);
			addEventListener(Event.DEACTIVATE, deactiveHandler);
			
			if (stage != null)
			{
				addToStageHandler();
			}
			else
			{
				addEventListener(Event.ADDED_TO_STAGE, addToStageHandler);
			}
			if (loaderInfo.bytesLoaded == loaderInfo.bytesTotal)
			{
				loadCompleteHandler();
			}
			else
			{
				loaderInfo.addEventListener(Event.COMPLETE, loadCompleteHandler);
			}
		}
		
		private function loadCompleteHandler(event:Event = null):void
		{
			_loadCompleted = true;
			completeValidateHandler();
		}
		
		private function addToStageHandler(event:Event = null):void
		{
			removeEventListener(Event.ADDED_TO_STAGE, addToStageHandler);
			_parameters = stage.loaderInfo.parameters;
			_stage = stage;
			_stage.scaleMode = StageScaleMode.NO_SCALE;
			_stage.align = StageAlign.TOP_LEFT;
			completeValidateHandler();
		}
		
		private function completeValidateHandler():void
		{
			if (_stage && _loadCompleted && hasEventListener(Event.COMPLETE))
			{
				dispatchEvent(new Event(Event.COMPLETE, true));
			}
		}
		
		private function deactiveHandler(event:Event):void
		{
			_active = false;
		}
		
		private function activeHandler(event:Event):void
		{
			_active = true;
		}
		
		static public function get stage():Stage
		{
			return _stage;
		}
		
		public static function get active():Boolean
		{
			return _active;
		}
		
		public static function get parameters():Object
		{
			return _parameters;
		}
		
		public static function get instance():Application
		{
			return _instance;
		}
		
		public function get parameters():Object
		{
			return _parameters;
		}
		
		public function get active():Boolean
		{
			return _active;
		}
		
		public function get startTime():Number
		{
			return _startTime;
		}
		
		public function get loaded():Boolean
		{
			return _loadCompleted;
		}
		
		/* INTERFACE common.system.ITypeObject */
		
		public function getType():Type
		{
			return ClassType.getType(this);
		}
	}
}