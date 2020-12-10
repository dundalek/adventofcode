const std = @import("std");
const print = std.debug.print;
const utils = @import("utils.zig");
const usize_asc = std.sort.asc(usize);
fn part1(adapters: []const usize) usize {
    var joltage: usize = 0;
    var diff1_count: usize = 0;
    var diff3_count: usize = 1;
    for (adapters) |adapter| {
        var diff = (adapter - joltage);
        if (diff == 1) {
            diff1_count += 1;
        } else if (diff == 3) {
            diff3_count += 1;
        }
        joltage = adapter;
    }
    return (diff1_count * diff3_count);
}

fn part2(numbers: []const usize) usize {
    var adapters = utils.alloc(usize, (numbers.len + 2));
    var visits = utils.alloc(usize, adapters.len);
    var i: usize = 0;
    while (i < numbers.len) : (i += 1) {
        adapters[(i + 1)] = numbers[i];
        visits[(i + 1)] = 0;
    }
    adapters[0] = 0;
    adapters[(adapters.len - 1)] = (3 + numbers[(numbers.len - 1)]);
    visits[0] = 1;
    visits[(visits.len - 1)] = 0;
    i = 0;
    while (i < adapters.len) : (i += 1) {
        var joltage = adapters[i];
        var visited = visits[i];
        var j: usize = (i + 1);
        while ((j < adapters.len) and (adapters[j] <= (joltage + 3))) : (j += 1) {
            visits[j] += visited;
        }
    }
    return visits[(visits.len - 1)];
}

pub fn main() void {
    var numbers = utils.readFileInts(usize, "inputs/day10.txt");
    std.sort.sort(usize, numbers, {}, usize_asc);
    print("{}\n", .{part1(numbers)});
    print("{}\n", .{part2(numbers)});
}
