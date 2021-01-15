:: """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
:: " Author: Renzo Xie
:: " renzoxie@gmail.com
:: " Created: 2018-09-16 07:06
:: " ModIFied: 2019-01-05 10:15
:: " Description: FOR MARRIOTT PROJECTS
:: " Version: 1.06
:: """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
:: [SECTION 0, GENERAL] 
:: ---------------------------------
@ECHO OFF
SETLOCAL enabledelayedexpansion
MODE CON:COLS=72 LINES=54
COLOR 3E
TITLE SAFLOK SYSTEM AUTO INSTALLER
ECHO -----------------------------------------
ECHO # INPUT C OR D THEN PRESS ENTER
ECHO # DEFAULT DRIVE C: AFTER 15 SECONDS
ECHO -----------------------------------------
ECHO INSTALL SAFLOK SYSTEM TO DRIVE: [C,D]?
CHOICE /C CD /T 15 /D C /M "INSTALL SAFLOK SYSTEM TO DRIVE:" >NUL 2>NUL
IF ERRORLEVEL 1 SET DRIVE=C
IF ERRORLEVEL 2 SET DRIVE=D
:: 
:: [SECTION 1, VARIABLES] 
:: ---------------------------------
:: [CONSTANT]
SET saflokVersion=5.45
SET lensPatchVersion=4.7.4
SET pollingPatchVersion=4.5
SET issPatchLensVersion=474
SET issPatchPollingVersion=450
SET myPath=%~dp0
:: [EXE]
SET saflokProgram=saflokProgram\setup.exe
SET saflokPMS=saflokPMS\setup.exe
SET saflokMessenger=saflokMessenger\setup.exe
SET saflokLENS=saflokLENS\AutoPlay\Install Script\Lens\en\setup.exe
SET pollingPatch=DigitalKeysPollingPatch%pollingPatchVersion%.exe
SET lensPatch=LENSPatch%lensPatchVersion%.exe
:: [ISS]
SET issFolder=ISS_FOR_%DRIVE%
SET programISS=Programsetup.iss
SET pmsISS=PMSsetup.iss
SET msgrISS=MSGRsetup.iss
SET lensISS=LENSsetup.iss
SET lensPatchISS=patchLens%issPatchLensVersion%.iss
SET pollingPatchISS=patchPolling%issPatchPollingVersion%.iss
:: [SQL]
SET sqlExpr=saflokLENS\AutoPlay\Install Script\Lens\en\ISSetupPrerequisites\{C38620DE-0463-4522-ADEA-C7A5A47D1FF6}\SQLEXPR_x86_ENU.exe
SET saPasswdUpdate=C:\Program Files (x86)\Microsoft SQL Server\100\Tools\Binn\OSQL.EXE
:: [FOLDERS]
SET shareName=SaflokData
SET srcHotelDataFolder=hotelData
SET srcConfigFilesFolder=configFiles
SET destHotelDataFolder=%DRIVE%:\SaflokV4\%shareName%
SET shareFolder=%DRIVE%:\SaflokV4\%shareName%
SET lensInstallFolder=%DRIVE%:\Program Files (x86)\KABA\Messenger Lens
SET patchFolder=patch%lensPatchVersion%
SET destPollingFolder=%DRIVE%:\Program Files (x86)\KABA\Messenger Lens\DigitalKeysPollingSoftware
SET destPmsServiceFolder=%DRIVE%:\Program Files (x86)\KABA\Messenger Lens\PMS Service
SET sqlInstallFolder=%DRIVE%:\Program Files (x86)\Microsoft SQL Server\100\Setup Bootstrap\SQLServer2008R2
:: [CONFIG FILES]
SET HH6ConfigFile=%DRIVE%:\SaflokV4\KabaSaflokHH6.exe.config
SET pollingServiceConfigFile=%destPollingFolder%\DigitalKeysPollingService.exe.config
SET lensPmsConfigFile=%destPmsServiceFolder%\LENS_PMS.exe.config
:: [POLLING SERVICE LOG]
SET pollingLog=C:\ProgramData\DormaKaba\Server\Polling\logs.log
:: [GUI PROGRAMS]
SET saflokClient=%DRIVE%:\SaflokV4\Saflok_Client.exe
SET saflokIRS=%DRIVE%:\SaflokV4\Saflok_IRS.EXE
SET saflokMsgrServer=%DRIVE%:\SaflokV4\Saflok_MsgrServer.exe
SET kabaManager=%DRIVE%:\Program Files (x86)\KABA\Messenger Lens\ServicesManager\KABA Services Manager.exe
SET saflokLauncherGui=%DRIVE%:\SaflokV4\Saflok_AppLauncher.exe
SET saflokCRSGui=%DRIVE%:\SaflokV4\Saflok_CRS.exe
SET saflokIRSGui=%DRIVE%:\saflokv4\saflok_IRS.exe
SET saflokSchedulerGui=%DRIVE%:\saflokv4\Saflok_SchedulerGUI.exe
SET saflokConfig=%DRIVE%:\SaflokV4\Saflok_config.exe
:: [SERVICES]
SET deviceMngr=DeviceManagerService
SET kIpEncoderSrv=KIPEncoderService
SET firebirdSrv=FirebirdGuardianDefaultInstance
SET saflokLauncherSrv=SaflokServiceLauncher
SET saflokCRSSrv=SaflokCRS
SET saflokSchedulerSrv=SaflokScheduler
SET saflokIRSSrv=SaflokIRS
SET saflokMSGRSrv=SaflokMSGR
SET saflokDHSP2MSGR=SAFLOKDHSPtoMSGRTranslator
SET saflokMSGR2DHSP=SAFLOKMSGRtoDHSPTranslator
SET hubGatewaySrv=MessengerNet_Hub Gateway Service
SET hubManagerSrv=MNet_HMS
SET pmsSrv=MNet_PMS Service
SET utilitySrv=MessengerNet_Utility Service
SET kdsSrv=Kaba_KDS
SET virtualEncoderSrv=VirtualEncoderService
SET pollingSrv=Kaba Digital Keys Polling Service
:: 
:: ==== BEGIN ====
::
:: [SECTION 2, PAGE HEADER] 
:: ---------------------------------
CLS
ECHO ^+--------------------------------------------^+
ECHO ^| FOR MARRIOTT PROJECTS (NEW/UPGRADE)        ^|
ECHO ^+--------------------------------------------^+
ECHO ^| SAFLOK VERSION %saflokVersion%                        ^|
ECHO ^| PREPARED BY: renzoxie^@gmail.com           ^|
ECHO ^+--------------------------------------------^+
ECHO NOTICE: YOU CHOSE TO DRIVE %DRIVE%:
ECHO.
TIMEOUT /T 2 /NOBREAK >NUL 2>NUL
:: 
:: [SECTION 3, INSTALL PROGRAM] 
:: ------------------------------------
:: 3.01, SAFLOK SYSTEM6000 INSTALLATION
:: ------------------------------------
IF NOT EXIST %saflokClient% (
ECHO ##^> INSTALLING SAFLOK PROGRAM ...
START "" /WAIT "%myPath%%saflokProgram%" /s /f1"%myPath%%issFolder%\%programISS%"
ECHO ==^> PROGRAM SETUP COMPLETE
TIMEOUT /T 2 /NOBREAK >NUL 2>NUL
) ELSE (
ECHO ==^> SAFLOK PROGRAM INSTALLED ALREADY.
)
ECHO.
TIMEOUT /T 2 /NOBREAK >NUL 2>NUL
::
:: -----------------------------
:: 3.02, SAFLOK PMS INSTALLATION
:: -----------------------------
IF NOT EXIST %saflokIRS% (
ECHO ##^> INSTALLING SAFLOK PMS ...
START "" /WAIT "%myPath%%saflokPMS%" /s /f1"%myPath%%issFolder%\%pmsISS%"
ECHO ==^> PMS SETUP COMPLETE
TIMEOUT /T 2 /NOBREAK >NUL 2>NUL
) ELSE (
ECHO ==^> SAFLOK PMS INSTALLED ALREADY.
)
ECHO.
TIMEOUT /T 2 /NOBREAK >NUL 2>NUL
::
:: ----------------------------------
:: 3.03, SAFLOK MESSENGER INSTALLATION
:: ----------------------------------
IF NOT EXIST %saflokMsgrServer% (
ECHO ##^> INSTALLING SAFLOK MESSENGER ...
START "" /WAIT "%myPath%%saflokMessenger%" /s /f1"%myPath%%issFolder%\%msgrISS%"
ECHO ==^> MESSENGER SETUP COMPLETE
TIMEOUT /T 2 /NOBREAK >NUL 2>NUL
) ELSE (
ECHO ==^> SAFLOK MESSENGER INSTALLED ALREADY.
)
ECHO.
TIMEOUT /T 2 /NOBREAK >NUL 2>NUL
::
:: ------------------------
:: 3.04, COPY DATABASE & SHARE FOLDER
:: ------------------------
IF NOT EXIST "%myPath%%srcHotelDataFolder%\SAFLOKDATAV2.GDB" (
ECHO ########################################################
ECHO # PLEASE COPY DATABASE FILES TO:
ECHO # "%myPath%%srcHotelDataFolder%"
ECHO ########################################################
ECHO.
ECHO ##^> INSTALLATION WILL EXIT IN 10 SECONDS.
TIMEOUT /T 10 >NUL
EXIT >NUL 2>NUL
)
NET STOP ^| FIND "%firebirdSrv%" > NUL 2>&1
IF %ERRORLEVEL% == 0 (
STOP "" NET START "%firebirdSrv%"
)
REM IF EXIST "%destHotelDataFolder%\SAFLOKDATAV2.GDB" (
REM ECHO ==^> SAFLOK GDB FILES EXIST ALREADY.
REM ) ELSE (
ROBOCOPY "%myPath%%srcHotelDataFolder%" "%destHotelDataFolder%" *.GDB /S >NUL 2>NUL
REM ) 
NET SHARE %shareName%="%shareFolder%" /REMARK:"Saflok Database Folder Share" /GRANT:"everyone",FULL >NUL 2>&1
IF %ERRORLEVEL% == 0 (
ECHO ==^> DATABASE FOLDER WAS SHARED ALREADY.
) ELSE (
ECHO ==^> DATABASE SET UP DONE.
)
TIMEOUT /T 2 /NOBREAK >NUL 2>NUL
ECHO.
TIMEOUT /T 2 /NOBREAK >NUL 2>NUL
::
:: ------------------------
:: 3.05 START FIREBIRD
:: ------------------------
START "" NET START "%firebirdSrv%"
TIMEOUT /T 5 /NOBREAK >NUL 2>NUL
::
:: [RUN SAFLOK CONFIG]
REM START "" /WAIT "%saflokConfig%"
REM TIMEOUT /T 5 /NOBREAK >NUL 2>NUL
::
:: ------------------------
:: 3.06 START SAFLOK LAUNCHER SERVICE
:: ------------------------
START "" NET START "%saflokLauncherSrv%"
TIMEOUT /T 5 /NOBREAK >NUL 2>NUL
::
:: ------------------------
:: 3.09 CHECK IIS FEATURES
:: ------------------------
ECHO ##^> CHECKING IIS FEATURES, PLEASE WAIT ...
SET list=IIS-WebServerRole NetFx4Extended-ASPNET45 IIS-RequestFiltering IIS-DefaultDocument IIS-NetFxExtensibility45 IIS-ApplicationInit IIS-ISAPIExtensions IIS-ISAPIFilter IIS-ASP IIS-ASPNET45 IIS-CGI
(FOR %%a IN (%list%) DO (
	DISM /online /get-featureinfo /featurename:%%a | FIND "State : Disabled" > NUL 2>&1
	IF %ERRORLEVEL% == 0 (
		DISM /online /enable-feature /featurename:%%a >NUL 2>&1
		ECHO ==^> %%a ENABLED.
	)
))
TIMEOUT /T 2 /NOBREAK >NUL 2>NUL
ECHO.
TIMEOUT /T 2 /NOBREAK >NUL 2>NUL
::
:: ------------------------
:: 3.10 LENS INSTALLATION
:: ------------------------
:: [SQL EXPRESS SLIENT]
ECHO ##^> PROCESSING SAFLOK MESSENGER LENS
ECHO ##^> NOTICE: THIS WILL TAKE SEVERAL MINUTES, PLEASE WAIT ...
TIMEOUT /T 3 /NOBREAK >NUL 2>NUL
IF NOT EXIST "%sqlInstallFolder%" (
ECHO ==^> SETTING UP MSSQL EXPRESS ...
START "" /WAIT "%myPath%%sqlExpr%" /qs /INSTANCENAME="LENSSQL" /ACTION="Install" /Hideconsole /IAcceptSQLServerLicenseTerms="True"  /FEATURES=SQLENGINE,SSMS /HELP="False" /INDICATEPROGRESS="True" /QUIETSIMPLE="True" /X86="True" /ERRORREPORTING="False" /SQMREPORTING="False" /SQLSVCSTARTUPTYPE="Automatic" /FILESTREAMLEVEL="0" /ENABLERANU="True" /SQLCOLLATION="Latin1_General_CI_AS" /SQLSVCACCOUNT="NT AUTHORITY\SYSTEM" /SQLSYSADMINACCOUNTS="BUILTIN\Administrators" /SECURITYMODE="SQL" /ADDCURRENTUSERASSQLADMIN="True" /TCPENABLED="1" /NPENABLED="0" /SAPWD="Sflok2015"
TIMEOUT /T 3 /NOBREAK >NUL 2>NUL
:: [UPDATE SQL PASSWORD]
START "" /WAIT "%saPasswdUpdate%" -S "localhost\lenssql" -I -E -Q "alter login [sa] with check_policy = off"
START "" /WAIT "%saPasswdUpdate%" -S "localhost\lenssql" -I -E -Q "sp_password NULL,'Lens2014','sa'"
ECHO ==^> MSSQL INSTALLATION COMPLETE.
TIMEOUT /T 2 /NOBREAK >NUL 2>NUL
) ELSE (
TIMEOUT /T 2 /NOBREAK >NUL 2>NUL
ECHO ==^> MSSQL SERVER 2008 R2 INSTALLED ALREADY.
)
ECHO.
TIMEOUT /T 2 /NOBREAK >NUL 2>NUL
:: [INSTALL LENS]
IF NOT EXIST "%lensInstallFolder%" (
ECHO ##^> INSTALLING MESSENGER LENS V%lensPatchVersion% ...
START "" /WAIT "%myPath%%saflokLENS%" /s /f1"%myPath%%issFolder%\%lensISS%"
TIMEOUT /T 3 /NOBREAK >NUL 2>NUL
:: [LENS PATCH 4.7.4]
START "" /WAIT "%myPath%%patchFolder%\%lensPatch%" /s /f1"%myPath%%issFolder%\%lensPatchISS%"
ECHO ==^> LENS INSTALLATION COMPLETE.
TIMEOUT /T 3 /NOBREAK >NUL 2>NUL
) ELSE (
ECHO ==^> MESSENGER LENS INSTALLED ALREADY.
)
:: [ALLOW EVERYONE ACCESS TO LENS FOLDER]
ICACLS "%lensInstallFolder%" /grant Everyone:(OI)(CI)F /T /C /Q >NUL 2>NUL
ECHO.
TIMEOUT /T 2 /NOBREAK >NUL 2>NUL
:: [POLLING PATCH 4.5]
IF NOT EXIST "%destPollingFolder%" (
ECHO ##^> INSTALLING POLLING SERVICE ...
START "" /WAIT "%myPath%%patchFolder%\%pollingPatch%" /s /f1"%myPath%%issFolder%\%pollingPatchISS%"
ECHO ==^> POLLING SERVICE INSTALLATION COMPLETE.
TIMEOUT /T 3 /NOBREAK >NUL 2>NUL
:: [COPY CONFIG FILES]
ROBOCOPY "%myPath%%srcConfigFilesFolder%" "%destPollingFolder%" DigitalKeysPollingService.exe.config /S >NUL 2>NUL
ROBOCOPY "%myPath%%srcConfigFilesFolder%" "%destPmsServiceFolder%" LENS_PMS.exe.config  /S >NUL 2>NUL
:: [UNHIDE FOLDER]
ATTRIB -h -s "%destPmsServiceFolder%"
ATTRIB -h -s "%destPollingFolder%"
TIMEOUT /T 3 /NOBREAK >NUL 2>NUL
) ELSE (
ECHO ==^> POLLING SERVICE INSTALLED ALREADY.
)
ECHO.
TIMEOUT /T 3 /NOBREAK >NUL 2>NUL
::
:: ------------------------
:: 3.12 CHECK SERVICEs
:: ------------------------
ECHO ##^> CHECKING SERVICES STATE ...
SET SvcName="DeviceManagerService" "KIPEncoderService" "Kaba_KDS" "MessengerNet_Hub Gateway Service" "MNet_HMS" "MNet_PMS Service" "Kaba Digital Keys Polling Service" "MessengerNet_Utility Service" "VirtualEncoderService"
FOR %%i IN (%SvcName%) DO (
SC QUERYEX "%%i" | FIND "STATE" | FIND /v "RUNNING" >NUL 2>&1
NET START %%i >NUL 2>NUL
ECHO %%i SERVICE HAS ALREADY BEEN STARTED.
)
ECHO.
TIMEOUT /T 3 /NOBREAK >NUL 2>NUL
:: }
:: [SECTION 4, CONFIG] 
:: ------------------------
:: 4.01 START KABA SERVICE MANAGER
:: ------------------------
ECHO ==^> STARTING KABA SERVICES MANAGER, DONE.
START "" "%kabaManager%"
::
:: ------------------------
:: 4.02 OPEN CONFIG FILES
:: ------------------------
START "" NOTEPAD.EXE "%HH6ConfigFile%"
TIMEOUT /T 5 /NOBREAK >NUL 2>NUL
START "" NOTEPAD.EXE "%pollingServiceConfigFile%"
TIMEOUT /T 5 /NOBREAK >NUL 2>NUL
START "" NOTEPAD.EXE "%lensPmsConfigFile%"
TIMEOUT /T 5 /NOBREAK >NUL 2>NUL
START "" NOTEPAD.EXE "%pollingLog%"
TIMEOUT /T 2 /NOBREAK >NUL 2>NUL
::
:: ------------------------
:: 4.03 OPENING IRS GUI
:: ------------------------
START "" "%saflokIRSGui%"
TIMEOUT /T 3 /NOBREAK >NUL 2>NUL
ECHO.
TIMEOUT /T 3 /NOBREAK >NUL 2>NUL
ECHO ##^> ALMOST DONE ...
:: 
:: [SECTION 5, SET SERVICES RECOVERY] 
:: ---------------------------------
SC FAILURE "%kdsSrv%" reset= 86400 actions= restart/5000/restart/5000/restart/5000 >NUL 2>NUL
SC FAILURE "%hubGatewaySrv%" reset= 86400 actions= restart/5000/restart/5000/restart/5000 >NUL 2>NUL
SC FAILURE "%hubManagerSrv%" reset= 86400 actions= restart/5000/restart/5000/restart/5000 >NUL 2>NUL
SC FAILURE "%pmsSrv%" reset= 86400 actions= restart/5000/restart/5000/restart/5000 >NUL 2>NUL
SC FAILURE "%utilitySrv%" reset= 86400 actions= restart/5000/restart/5000/restart/5000 >NUL 2>NUL
SC FAILURE "%pollingSrv%" reset= 86400 actions= restart/5000/restart/5000/restart/5000 >NUL 2>NUL
SC FAILURE "%virtualEncoderSrv%" reset= 86400 actions= restart/5000/restart/5000/restart/5000 >NUL 2>NUL
SC CONFIG "%kdsSrv%" start= delayed-auto >NUL 2>NUL
SC CONFIG "%hubGatewaySrv%" start= delayed-auto >NUL 2>NUL
SC CONFIG "%hubManagerSrv%" start= delayed-auto >NUL 2>NUL
SC CONFIG "%pmsSrv%" start= delayed-auto >NUL 2>NUL
SC CONFIG "%utilitySrv%" start= delayed-auto >NUL 2>NUL
SC CONFIG "%pollingSrv%" start= delayed-auto >NUL 2>NUL
SC CONFIG "%virtualEncoderSrv%" start= delayed-auto >NUL 2>NUL
TIMEOUT /T 3 /NOBREAK >NUL 2>NUL
ECHO.
:: 
:: [SECTION 6, PAGE FOOTER] 
:: ---------------------------------
TIMEOUT /T 3 /NOBREAK >NUL 2>NUL
ECHO ==^> 100%%
ECHO.
TIMEOUT /T 6 /NOBREAK >NUL 2>NUL
ECHO ------------------------
ECHO **** CONGRATULATION ****
ECHO ------------------------
ECHO.
PAUSE >NUL 2>NUL
ENDLOCAL
:: 
:: ==== END ====
