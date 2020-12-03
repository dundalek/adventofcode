const std = @import("std");
const print = std.debug.print;
const utils = @import("utils.zig");
fn part1(lines: [][]const u8, right: usize, down: usize) usize {
    var row: usize = 0;
    var col: usize = 0;
    var count: usize = 0;
    while (true) {
        col += right;
        row += down;
        if (row >= lines.len) {
            break;
        }
        var line = lines[row];
        if (line[(col % line.len)] == '#') {
            count += 1;
        }
    }
    return count;
}

fn part2(lines: [][]const u8, slopes: [][2]usize) usize {
    var result: usize = 1;
    for (slopes) |slope| {
        result *= part1(lines, slope[0], slope[1]);
    }
    return result;
}

pub fn main() void {
    var lines = utils.readFileLines("inputs/day03.txt");
    print("{}\n", .{part1(lines, 3, 1)});
    var slopes = [_][2]usize{ .{ 1, 1 }, .{ 3, 1 }, .{ 5, 1 }, .{ 7, 1 }, .{ 1, 2 } };
    print("{}\n", .{part2(lines, slopes[0..])});
}
