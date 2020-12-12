const std = @import("std");
const print = std.debug.print;
const utils = @import("utils.zig");
fn part1(lines: [][]const u8) !isize {
    var v: isize = 0;
    var h: isize = 0;
    var d: isize = 90;
    for (lines) |line| {
        var n = utils.parseInt(isize, line[1..]);
        switch (line[0]) {
            'N' => {
                v += n;
            },
            'S' => {
                v -= n;
            },
            'E' => {
                h += n;
            },
            'W' => {
                h -= n;
            },
            'L' => {
                d = @rem((d + 360) - n, 360);
            },
            'R' => {
                d = @rem(d + n, 360);
            },
            'F' => switch (d) {
                0 => {
                    v += n;
                },
                180 => {
                    v -= n;
                },
                90 => {
                    h += n;
                },
                270 => {
                    h -= n;
                },
                else => unreachable,
            },
            else => unreachable,
        }
    }
    var va = try std.math.absInt(v);
    var ha = try std.math.absInt(h);
    return (va + ha);
}

fn part2(lines: [][]const u8) !isize {
    var v: isize = 0;
    var h: isize = 0;
    var wv: isize = 1;
    var wh: isize = 10;
    for (lines) |line| {
        var n = utils.parseInt(isize, line[1..]);
        switch (line[0]) {
            'N' => {
                wv += n;
            },
            'S' => {
                wv -= n;
            },
            'E' => {
                wh += n;
            },
            'W' => {
                wh -= n;
            },
            'L' => {
                var i: usize = 0;
                while (i < @divFloor(n, 90)) : (i += 1) {
                    var t = wh;
                    wh = -wv;
                    wv = t;
                }
            },
            'R' => {
                var i: usize = 0;
                while (i < @divFloor(n, 90)) : (i += 1) {
                    var t = wv;
                    wv = -wh;
                    wh = t;
                }
            },
            'F' => {
                v += (n * wv);
                h += (n * wh);
            },
            else => unreachable,
        }
    }
    var va = try std.math.absInt(v);
    var ha = try std.math.absInt(h);
    return (va + ha);
}

pub fn main() !void {
    var lines = utils.readFileLines("inputs/day12.txt");
    print("{}\n", .{part1(lines)});
    print("{}\n", .{part2(lines)});
}
