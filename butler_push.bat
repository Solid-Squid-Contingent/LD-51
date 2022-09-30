rmdir build /S / Q
mkdir build
mkdir build\windows
mkdir build\linux
godot --export "windows" .\build\windows\???.exe
godot --export linux .\build\linux\???.x86_64
butler push build\windows solid-squid-contingent/???:windows
butler push build\linux solid-squid-contingent/???:linux
PAUSE
