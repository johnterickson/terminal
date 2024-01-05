setlocal

set TEMP=%CD:~0,3%TEMP
set TMP=%TEMP%
mkdir %TEMP%

rmdir /s /q ..\MSBuildCacheLogs
move MSBuildCacheLogs ..

move /Y msbuild.binlog ..

set _RAZZLE_ARGS=
IF "%PLATFORM%"=="x86" (
    set _RAZZLE_ARGS=x86
)

set MSBUILDDEBUGONSTART_ORIGINAL=%MSBUILDDEBUGONSTART%
set MSBUILDDEBUGONSTART=0
git submodule update --init --recursive
git clean -xdf
set OpenConBuild=
IF "%SYSTEM_TEAMFOUNDATIONCOLLECTIONURI%"=="https://dev.azure.com/artifactsandbox0/" (
    for /F %%I in ('az account get-access-token --query accessToken --output tsv') DO (set "SYSTEM_ACCESSTOKEN=%%I")
)
call tools\razzle.cmd %_RAZZLE_ARGS%
set MSBUILDDEBUGONSTART=%MSBUILDDEBUGONSTART_ORIGINAL%
echo MSBUILDDEBUGONSTART=%MSBUILDDEBUGONSTART%
set EXTRA_MSBUILD_ARGS=/graph /restore:false /nr:false /reportfileaccesses /bl /p:MSBuildCacheEnabled=true /t:Build;Test %*
call bcz.cmd no_clean