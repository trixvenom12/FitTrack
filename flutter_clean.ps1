Write-Host "Cleaning Flutter project..."

Remove-Item -Recurse -Force .dart_tool -ErrorAction SilentlyContinue
Remove-Item -Recurse -Force build -ErrorAction SilentlyContinue
Remove-Item -Force pubspec.lock -ErrorAction SilentlyContinue

flutter clean
flutter pub get

Write-Host "Clean complete."
