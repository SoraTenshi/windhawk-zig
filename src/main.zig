const std = @import("std");
const unicode = std.unicode;
const win = std.os.windows;

const zwin = @import("win32").everything;

const wh_find_symbol = packed struct {
    symbol: win.LPWSTR,
    address: ?*anyopaque,
};

const api_pointer = packed struct {
    Wh_Log:               fn (win.LPCWSTR) callconv(.C) void,
    Wh_GetIntValue:       fn (win.LPWSTR, c_int) callconv(.C) c_int,
    Wh_SetIntValue:       fn (win.LPWSTR, c_int) callconv(.C) win.BOOL,
    Wh_GetStringValue:    fn (win.LPWSTR, win.LPWSTR, usize) callconv(.C) usize,
    Wh_GetBinaryValue:    fn (win.LPWSTR, ?*win.BYTE, usize) callconv(.C) usize,
    Wh_SetBinaryValue:    fn (win.LPWSTR, ?*win.BYTE, usize) callconv(.C) win.BOOL,
    Wh_GetIntSetting:     fn (win.LPWSTR) callconv(.C) c_int,
    Wh_GetStringSetting:  fn (win.LPWSTR) callconv(.C) win.LPWSTR,
    Wh_FreeStringSetting: fn (win.LPWSTR) callconv(.C) void,
    Wh_SetFunctionHook:   fn (?*anyopaque, ?*anyopaque, ?**anyopaque) callconv(.C) win.BOOL,
    Wh_FindFirstSymbol:   fn (win.HMODULE, win.LPWSTR, ?*wh_find_symbol) callconv(.C) win.HANDLE,
    Wh_FindNextSymbol:    fn (win.HANDLE, ?*wh_find_symbol) callconv(.C) win.BOOL,
    Wh_FindCloseSymbol:   fn (win.HANDLE) callconv(.C) void,
};

/// Utility Function to minimally create "wide" string. (UTF-16)
fn L(comptime str: []const u8) win.LPCWSTR {
    return unicode.utf8ToUtf16LeStringLiteral(str);
}

var windhawk_apis: ?*api_pointer = null;

export fn Wh_ModInit(apis: *api_pointer) callconv(.C) win.BOOL {
    windhawk_apis = apis;
    windhawk_apis.?.Wh_Log(L("Init"));
    return win.TRUE;
}

export fn Wh_ModAfterInit() callconv(.C) void {
    windhawk_apis.?.Wh_Log(L("ModAfterInit"));
    _ = zwin.MessageBoxW(null, L("Hello from Zig! :)"), L("Ziggy"), zwin.MESSAGEBOX_STYLE.HELP);
}

export fn Wh_ModBeforeUninit() callconv(.C) void {
    windhawk_apis.?.Wh_Log(L("ModBeforeUninit"));
    _ = zwin.MessageBoxW(null, L("U really want to exit already? :("), L("Ziggy"), zwin.MESSAGEBOX_STYLE.CANCELTRYCONTINUE);
}

export fn Wh_ModUninit() callconv(.C) void {
    windhawk_apis.?.Wh_Log(L("Uninit"));
}

export fn Wh_ModSettingsChanged() callconv(.C) void {
    windhawk_apis.?.Wh_Log(L("SettingsChanged"));
}
