package common.system.application.controllers
{
	import common.system.ClassType;
	import common.system.IDisposable;
	import common.system.TypeObject;
	import flash.display.Stage;
	import flash.display.StageQuality;
	
	/**
	 * ...
	 * @author dorofiy.com
	 */
	public class QualityController extends TypeObject implements IDisposable
	{
		//--------------------------------------------------------------------------
		//     
		//	PRIVATE VARIABLES 
		//     
		//--------------------------------------------------------------------------
		
		private var _stage:Stage;
		
		//----------------------------------
		//	CONSTRUCTOR
		//----------------------------------
		
		public function QualityController(stage:Stage)
		{
			if (stage == null)
			{
				throw new ArgumentError(ClassType.getQualifiedClassName(this) + ", argument can not be null");
			}
			_stage = stage;
		}
		
		//--------------------------------------------------------------------------
		//     
		//	PUBLIC PROPERTIES 
		//     
		//--------------------------------------------------------------------------
		
		public function get isBest():Boolean
		{
			return _stage.quality == "best";
		}
		
		public function get isHigh():Boolean
		{
			return _stage.quality == "high";
		}
		
		public function get isHigh_16X16():Boolean
		{
			return _stage.quality == "16x16";
		}
		
		public function get isHigh_16X16_LINEAR():Boolean
		{
			return _stage.quality == "16x16linear";
		}
		
		public function get isHigh_8X8():Boolean
		{
			return _stage.quality == "8x8";
		}
		
		public function get isHigh_8X8_LINEAR():Boolean
		{
			return _stage.quality == "8x8linear";
		}
		
		public function get isLow():Boolean
		{
			return _stage.quality == "low";
		}
		
		public function get isMedium():Boolean
		{
			return _stage.quality == "medium";
		}
		
		public function set current(value:String):void
		{
			_stage.quality = value;
		}
		
		public function get current():String
		{
			return _stage.quality;
		}
		
		//--------------------------------------------------------------------------
		//     
		//	PUBLIC METHODS 
		//     
		//--------------------------------------------------------------------------
		
		public function best():void
		{
			_stage.quality == "best";
		}
		
		public function high():void
		{
			_stage.quality == "high";
		}
		
		public function high_16X16():void
		{
			if ("16x16" in StageQuality)
			{
				_stage.quality == "16x16";
			}
			else
			{
				high();
			}
		}
		
		public function high_16X16_LINEAR():void
		{
			if ("16x16linear" in StageQuality)
			{
				_stage.quality == "16x16linear";
			}
			else
			{
				high();
			}
		}
		
		public function high_8X8():void
		{
			if ("8x8" in StageQuality)
			{
				_stage.quality == "8x8";
			}
			else
			{
				high();
			}
		}
		
		public function high_8X8_LINEAR():void
		{
			if ("8x8linear" in StageQuality)
			{
				_stage.quality == "8x8linear";
			}
			else
			{
				high();
			}
		}
		
		public function low():void
		{
			_stage.quality == "low";
		}
		
		public function medium():void
		{
			_stage.quality == "medium";
		}
		
		/* INTERFACE common.system.IDisposable */
		
		public function dispose():void
		{
			_stage = null;
		}
	}
}