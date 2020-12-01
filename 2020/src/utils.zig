const std = @import("std");
pub fn readFile(path: []const u8) []const u8 {
    const data = std.fs.cwd().readFileAlloc(std.heap.page_allocator, path, std.math.maxInt(usize)) catch |_| {
        unreachable;
    };
    return std.mem.trim(u8, data, "\n");
}

pub fn parseInt(comptime T: type, str: []const u8) T {
    return std.fmt.parseInt(T, str, 10) catch |_| {
        unreachable;
    };
}

pub fn IntIterator(comptime T: type) type {
    return struct {
        const Self = @This();
        it: std.mem.SplitIterator,
        pub fn next(self: *Self) ?T {
            const untrimmed = self.it.next() orelse return null;
            const trimmed = std.mem.trim(u8, untrimmed, " ");
            if (trimmed.len == 0) return null else return parseInt(T, trimmed);
        }

        pub fn new(in: []const u8, sep: []const u8) Self {
            return Self{
                .it = std.mem.split(in, sep),
            };
        }
    };
}
