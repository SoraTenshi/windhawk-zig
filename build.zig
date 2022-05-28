const std = @import("std");

pub fn build(b: *std.build.Builder) void {
    var target = b.standardTargetOptions(std.build.Builder.StandardTargetOptionsArgs{
        .default_target = std.zig.CrossTarget{
            .os_tag = std.Target.Os.Tag.windows,
            .cpu_arch = std.Target.Cpu.Arch.x86_64,
        }
    });
    const lib64 = b.addSharedLibrary("windhawk_zig", "src/main.zig", std.build.LibExeObjStep.SharedLibKind.unversioned);
    lib64.addPackagePath("win32", "lib/zigwin32/win32.zig");
    lib64.strip = false;
    lib64.setBuildMode(std.builtin.Mode.ReleaseFast);
    lib64.setTarget(target);
    lib64.install();
}
