const std = @import("std");
const print = std.debug.print;
const utils = @import("utils.zig");
fn readNum(marker: u8, s: []const u8) usize {
    var result: usize = 0;
    for (s) |c| {
        var bit: usize = if (c == marker) 1 else 0;
        result = (result << 1) | bit;
    }
    return result;
}

const usize_asc = std.sort.asc(usize);
fn intSum(n: usize) usize {
    return ((n * (n + 1)) / 2);
}

pub fn main() void {
    var lines = utils.readFileLines("inputs/day05.txt");
    var max_id: usize = 0;
    var sum: usize = 0;
    var seats = utils.alloc(usize, lines.len);
    for (lines) |line, i| {
        var row = readNum('B', line[0..7]);
        var col = readNum('R', line[7..]);
        var seat = ((row * 8) + col);
        max_id = std.math.max(max_id, seat);
        seats[i] = seat;
        sum += seat;
    }
    print("{}\n", .{max_id});
    std.sort.sort(usize, seats, {}, usize_asc);
    var i: usize = 1;
    while ((i < seats.len)) {
        if (1 != (seats[i] - seats[(i - 1)])) {
            print("{}\n", .{(seats[i] - 1)});
            break;
        }
        i += 1;
    }
    var min_id: usize = 11;
    var total_sum = (intSum(max_id) - intSum(min_id));
    print("{}\n", .{((total_sum - sum) + min_id)});
}
