package okapp.core
{
	import common.system.application.Application;
	import common.system.application.controllers.DisplayStateController;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.FullScreenEvent;
    
    /**
     * ...
     * @author dorofiy.com
     */
    public class GameApplication extends Application
    {
        private var _fullScreen:Boolean;
        private var _screenWidth:int;
        private var _screenHeight:int;
        private var _displayState:DisplayStateController;
        private var _stage:Stage;
        
        public function GameApplication(allowDomain:String = "*", allowInsecureDomain:String = "*")
        {
            super(allowDomain, allowInsecureDomain);
            addEventListener(Event.ADDED_TO_STAGE, toStageHandler);
        }
        
        public function set fullScreen(value:Boolean):void
        {
            if (value != _fullScreen)
            {
                _displayState.fullScreenInteractive();
                resetScreenSize();
            }
        }
        
        public function get fullScreen():Boolean
        {
            return _fullScreen;
        }
        
        public function get screenWidth():int
        {
            return _screenWidth;
        }
        
        public function get screenHeight():int
        {
            return _screenHeight;
        }
        
        protected function resetScreenSize():void
        {
            _screenWidth = _stage.stageWidth;
            _screenHeight = _stage.stageHeight;
        }
        
        private function toStageHandler(event:Event):void
        {
            removeEventListener(Event.ADDED_TO_STAGE, toStageHandler);
            _stage = stage;
            _stage.addEventListener(Event.RESIZE, resizeHandler);
            _stage.addEventListener(FullScreenEvent.FULL_SCREEN, fullScreenHandler);
            _displayState = new DisplayStateController(_stage);
            _fullScreen = _displayState.isFullScreen || _displayState.isFullScreenInteractive;
            resetScreenSize();
        }
        
        private function resizeHandler(event:Event):void
        {
            resetScreenSize();
        }
        
        private function fullScreenHandler(event:FullScreenEvent):void
        {
            _fullScreen = event.fullScreen;
            resetScreenSize();
        }
    }
}