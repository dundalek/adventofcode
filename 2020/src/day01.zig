const std = @import("std");
const print = std.debug.print;
const utils = @import("utils.zig");
pub fn part1(input: []const u8) void {
    var it_a = utils.IntIterator(u64).new(input, "\n");
    while (it_a.next()) |a| {
        var it_b = utils.IntIterator(u64).new(input, "\n");
        while (it_b.next()) |b| {
            if ((a + b) == 2020) {
                print("{}\n", .{(a * b)});
                return;
            }
        }
    }
}

pub fn part2(input: []const u8) void {
    var it_a = utils.IntIterator(u64).new(input, "\n");
    while (it_a.next()) |a| {
        var it_b = utils.IntIterator(u64).new(input, "\n");
        while (it_b.next()) |b| {
            var it_c = utils.IntIterator(u64).new(input, "\n");
            while (it_c.next()) |c| {
                if ((a + b + c) == 2020) {
                    print("{}\n", .{(a * b * c)});
                    return;
                }
            }
        }
    }
}

pub fn main() void {
    const input = utils.readFile("inputs/day01.txt");
    part1(input);
    part2(input);
}
