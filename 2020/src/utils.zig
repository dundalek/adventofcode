const std = @import("std");
pub const regex = @import("zig-regex/src/regex.zig").Regex;
pub fn alloc(comptime T: type, n: anytype) []T {
    return std.heap.page_allocator.alloc(T, n) catch |_| {
        unreachable;
    };
}

pub fn readFile(path: []const u8) []const u8 {
    const data = std.fs.cwd().readFileAlloc(std.heap.page_allocator, path, std.math.maxInt(usize)) catch |_| {
        unreachable;
    };
    return std.mem.trim(u8, data, "\n");
}

pub fn count(comptime T: type, in: []const T, e: T) usize {
    var c: usize = 0;
    for (in) |x| {
        if (x == e) {
            c += 1;
        }
    }
    return c;
}

pub fn splitByte(data: []const u8, b: u8) [][]const u8 {
    var sep = [_]u8{b};
    var groups = alloc([]const u8, (count(u8, data, b) + 1));
    var it = std.mem.split(data, sep[0..]);
    for (groups) |_, i| {
        groups[i] = (it.next() orelse unreachable);
    }
    return groups;
}

pub fn readFileLines(path: []const u8) [][]const u8 {
    return splitByte(readFile(path), '
');
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

pub fn strEql(a: []const u8, b: []const u8) bool {
    return std.mem.eql(u8, a, b);
}
