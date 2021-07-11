const std = @import("std");
const print = std.debug.print;
const utils = @import("utils.zig");
pub fn checkSatisfy(preamble: []const usize, num: usize) bool {
    var i: usize = 0;
    while (i < preamble.len) : (i += 1) {
        var j: usize = (i + 1);
        while (j < preamble.len) : (j += 1) {
            if (num == (preamble[i] + preamble[j])) {
                return true;
            }
        }
    }
    return false;
}

pub fn findMin(numbers: []const usize) usize {
    var min: usize = std.math.maxInt(usize);
    for (numbers) |num| {
        if (num < min) {
            min = num;
        }
    }
    return min;
}

pub fn findMax(numbers: []const usize) usize {
    var max: usize = 0;
    for (numbers) |num| {
        if (max < num) {
            max = num;
        }
    }
    return max;
}

pub fn findRangeSum(numbers: []const usize, sum: usize) usize {
    var i: usize = 0;
    while (i < numbers.len) : (i += 1) {
        var acc: usize = numbers[i];
        var j: usize = (i + 1);
        while ((j < numbers.len) and (acc < sum)) : (j += 1) {
            acc += numbers[j];
            if (acc == sum) {
                var range = numbers[i..(j + 1)];
                return (findMin(range) + findMax(range));
            }
        }
    }
    return 0;
}

pub fn main() void {
    const input = utils.readFile("inputs/day09.txt");
    var numbers = utils.alloc(usize, utils.count(u8, input, '
') + 1);
    var it = utils.IntIterator(usize).new(input, "\n");
    var i: usize = 0;
    while (it.next()) |num| {
        numbers[i] = num;
        i += 1;
    }
    var preamble: [25]usize = undefined;
    i = 0;
    while (i < preamble.len) : (i += 1) {
        preamble[i] = numbers[i];
    }
    var part1: usize = undefined;
    var j: usize = 0;
    while (i < numbers.len) : ({
        i += 1;
        j = (j + 1) % preamble.len;
    }) {
        var num = numbers[i];
        if (!checkSatisfy(&preamble, num)) {
            part1 = num;
            break;
        }
        preamble[j] = num;
    }
    print("{}\n", .{part1});
    print("{}\n", .{findRangeSum(numbers, part1)});
}
