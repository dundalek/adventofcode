const std = @import("std");
const print = std.debug.print;
const utils = @import("utils.zig");
const Bus = struct {
    num: usize,
    offset: usize,
};
pub fn parse(line: []const u8) []Bus {
    var cnt = ((utils.count(u8, line, ',') + 1) - utils.count(u8, line, 'x'));
    var buses = utils.alloc(Bus, cnt);
    var i: usize = 0;
    var offset: usize = 0;
    var it = std.mem.split(line, ",");
    while (it.next()) |bus_str| {
        if (bus_str[0] != 'x') {
            buses[i] = .{
                .num = utils.parseInt(usize, bus_str),
                .offset = offset,
            };
            i += 1;
        }
        offset += 1;
    }
    return buses;
}

pub fn cmpBusDesc(context: void, a: Bus, b: Bus) bool {
    return (a.num > b.num);
}

pub fn part1(earliest_time: usize, buses: []Bus) usize {
    var min_time: usize = std.math.maxInt(usize);
    var min_bus: usize = undefined;
    for (buses) |bus| {
        var num = bus.num;
        var time = (num - (earliest_time % num));
        if (time < min_time) {
            min_time = time;
            min_bus = num;
        }
    }
    return (min_time * min_bus);
}

pub fn part2BruteForce(buses: []Bus) usize {
    std.sort.sort(Bus, buses, {}, cmpBusDesc);
    var i: usize = 1;
    while (true) {
        var t = ((i * buses[0].num) - buses[0].offset);
        var j: usize = 1;
        while (j < buses.len) : (j += 1) {
            var num = buses[j].num;
            var offset = buses[j].offset;
            if (!(((t + offset) % num) == 0)) {
                break;
            }
        }
        if (j == buses.len) {
            return t;
        }
        i += 1;
    }
}

pub fn main() !void {
    var lines = utils.readFileLines("inputs/day13.txt");
    var earliest_time = utils.parseInt(usize, lines[0]);
    var buses = parse(lines[1]);
    print("{}\n", .{part1(earliest_time, buses)});
    print("{}\n", .{part2BruteForce(buses)});
}
