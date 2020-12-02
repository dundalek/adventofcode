const std = @import("std");
const print = std.debug.print;
const utils = @import("utils.zig");
pub fn main() void {
    const input = utils.readFile("inputs/day02.txt");
    var lines_it = std.mem.tokenize(input, "\n");
    var part1_count: u64 = 0;
    var part2_count: u64 = 0;
    while (lines_it.next()) |line| {
        var tokens_it = std.mem.tokenize(line, " ");
        var num_it = std.mem.tokenize(tokens_it.next().?, "-");
        var min = utils.parseInt(u64, num_it.next().?);
        var max = utils.parseInt(u64, num_it.next().?);
        var character = tokens_it.next().?[0];
        var password = tokens_it.next().?;
        var count: u64 = 0;
        for (password) |c| {
            if (c == character) {
                count += 1;
            }
        }
        if ((min <= count) and (count <= max)) {
            part1_count += 1;
        }
        var first_valid = (password[(min - 1)] == character);
        var second_valid = (password[(max - 1)] == character);
        if ((first_valid and (!second_valid)) or ((!first_valid) and second_valid)) {
            part2_count += 1;
        }
    }
    print("{}\n{}\n", .{ part1_count, part2_count });
}
