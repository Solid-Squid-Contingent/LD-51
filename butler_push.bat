rmdir build /S / Q
mkdir build
mkdir build\windows
mkdir build\web
mkdir build\linux
godot --export "windows" .\build\windows\binary-blasterz.exe
godot --export "web" .\build\web\index.html
godot --export "linux" .\build\linux\binary-blasterz.x86_64
butler push build\windows solid-squid-contingent/binary-blasterz:windows
butler push build\web solid-squid-contingent/binary-blasterz:web
butler push build\linux solid-squid-contingent/binary-blasterz:linux
PAUSE
