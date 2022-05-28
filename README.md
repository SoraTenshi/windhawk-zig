# windhawk-zig
This is a PoC which can be loaded via Windhawk

This is the "foreign" part of [this repository](https://github.com/diewellenlaenge/wh-cdecl-wrapper)

# Setup
- Download [zig](https://ziglang.org/)
- Clone this repo
- `$ git submodule init`
- `$ git submodule update`
- `$ {path/to/zig build}` to create the .dll 
- the dll can be found at: `${Workspace}/zig-out/lib/windhawk_zig.dll`
