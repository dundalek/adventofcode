const std = @import("std");
const print = std.debug.print;
const utils = @import("utils.zig");
pub fn main() !void {
    var part1_count: usize = 0;
    var part2_count: usize = 0;
    const input = utils.readFile("inputs/day06.txt");
    var it = std.mem.split(input, "\n\n");
    while (it.next()) |group| {
        var answers = ([_]usize{0} ** (('z' - 'a') + 1));
        var person_count: usize = 0;
        var answers_it = std.mem.split(group, "\n");
        while (answers_it.next()) |person_answers| {
            person_count += 1;
            for (person_answers) |c| {
                if (('a' <= c) and (c <= 'z')) {
                    answers[(c - 'a')] += 1;
                }
            }
        }
        for (answers) |a| {
            if (0 < a) {
                part1_count += 1;
            }
            if (a == person_count) {
                part2_count += 1;
            }
        }
    }
    print("{}\n", .{part1_count});
    print("{}\n", .{part2_count});
}
