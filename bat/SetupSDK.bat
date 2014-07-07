:user_configuration

:: Path to Flex SDK
set FLEX_SDK=C:\Users\nick1_000\AppData\Local\FlashDevelop\Apps\ascsdk\4.0.0


:validation
if not exist "%FLEX_SDK%" goto flexsdk
goto succeed

:flexsdk
echo.
echo ERROR: incorrect path to Flex SDK in 'bat\SetupSDK.bat'
echo.
echo %FLEX_SDK%
echo.
if %PAUSE_ERRORS%==1 pause
exit

:succeed
set PATH=%PATH%;%FLEX_SDK%\bin

