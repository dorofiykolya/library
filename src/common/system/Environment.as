package common.system
{
	import flash.system.Capabilities;
	
	/**
	 * ...
	 * @author dorofiy.com
	 */
	public class Environment
	{
		public function Environment()
		{
		
		}
		
		public static const isDebugger:Boolean = Capabilities.isDebugger;
		public static const playerType:String = Capabilities.playerType;
		public static const os:String = Capabilities.os;
		public static const manufacturer:String = Capabilities.manufacturer;
		public static const screenDPI:Number = Capabilities.screenDPI;
		public static const screenResolutionX:Number = Capabilities.screenResolutionX;
		public static const screenResolutionY:Number = Capabilities.screenResolutionY;
		public static const isDesktop:Boolean = playerType == "Desktop";
		public static const isActiveX:Boolean = playerType == "ActiveX";
		public static const isPlugIn:Boolean = playerType == "PlugIn";
		public static const isStandAlone:Boolean = playerType == "StandAlone";
		public static const isExternal:Boolean = playerType == "External";
		public static const isWindows:Boolean = os.search("Windows") != -1;
		public static const isMacOS:Boolean = os.search("Mac OS") != -1;
		public static const isLinux:Boolean = os.search("Linux") != -1;
		public static const isAndroid:Boolean = manufacturer.indexOf('Android') != -1 || os.search("Andoid") != -1;
		public static const isIOS:Boolean = manufacturer.indexOf('iOS') != -1;
		public static const isIphone:Boolean = os.search("iPhone") != -1;
		public static const isIpad:Boolean = os.search("iPad") != -1;
		public static const isMobile:Boolean = isAndroid || isIOS || isIphone || isIpad;
		
		public static function get language():String
		{
			return Capabilities.language;
		}
		
		public static function get languages():Array
		{
			if (Object(Capabilities).hasOwnProperty("languages"))
			{
				return Capabilities["languages"];
			}
			return null;
		}
	}
}