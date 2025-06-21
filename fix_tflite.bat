@echo off
setlocal ENABLEEXTENSIONS

echo ==============================
echo ✅ Fixing Android NDK Version
echo ==============================

set APP_BUILD_GRADLE=android\app\build.gradle.kts
set NDK_VERSION_LINE=ndkVersion = "27.0.12077973"

REM Add NDK version if not already present
findstr /C:"ndkVersion" %APP_BUILD_GRADLE% >nul
if %errorlevel% neq 0 (
    echo Inserting ndkVersion into %APP_BUILD_GRADLE%
    powershell -Command "(Get-Content '%APP_BUILD_GRADLE%') -replace 'android \{', 'android {\r`n    %NDK_VERSION_LINE%' | Set-Content '%APP_BUILD_GRADLE%'"
)

echo ==============================
echo ✅ Fixing tflite build.gradle
echo ==============================

set TFLITE_GRADLE=%USERPROFILE%\AppData\Local\Pub\Cache\hosted\pub.dev\tflite-1.1.2\android\build.gradle

REM Replace compile() with implementation()
powershell -Command "(Get-Content '%TFLITE_GRADLE%') -replace '\bcompile\(', 'implementation(' | Set-Content '%TFLITE_GRADLE%'"

REM Add namespace to tflite build.gradle if missing
findstr /C:"namespace" %TFLITE_GRADLE% >nul
if %errorlevel% neq 0 (
    echo Adding namespace to tflite build.gradle
    powershell -Command "(Get-Content '%TFLITE_GRADLE%') -replace 'android \{', 'android {\r`n    namespace \"sq.flutter.tflite\"' | Set-Content '%TFLITE_GRADLE%'"
)

echo ==============================
echo 🧹 Cleaning build files
echo ==============================

REM Clean old build artifacts
rd /s /q .dart_tool 2>nul
rd /s /q build 2>nul
del /f /q pubspec.lock 2>nul

echo ==============================
echo 📦 Running flutter pub get
echo ==============================

flutter pub get

echo.
echo ✅ ALL FIXES APPLIED SUCCESSFULLY!
pause
