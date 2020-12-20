const std = @import("std");
const print = std.debug.print;
const utils = @import("utils.zig");
const size: usize = 10;
const Tile = struct {
    id: usize,
    edges: [4][10]u8,
};
fn parseTile(input: []const u8, tile: *Tile) void {
    var it = std.mem.split(input, "\n");
    var first_line = it.next().?;
    tile.id = utils.parseInt(usize, first_line[5..(first_line.len - 1)]);
    var i: usize = 0;
    while (it.next()) |line| {
        if (i == 0) {
            std.mem.copy(u8, &tile.edges[0], line);
        }
        if (i == (size - 1)) {
            std.mem.copy(u8, &tile.edges[3], line);
        }
        tile.edges[1][i] = line[0];
        tile.edges[2][i] = line[(line.len - 1)];
        i += 1;
    }
}

fn parseTiles(input: []const u8) []Tile {
    var cnt: usize = 0;
    var it = std.mem.split(input, "\n\n");
    while (it.next()) |_| {
        cnt += 1;
    }
    var tiles = utils.alloc(Tile, cnt);
    var i: usize = 0;
    it = std.mem.split(input, "\n\n");
    while (it.next()) |tile_input| {
        parseTile(tile_input, &tiles[i]);
        i += 1;
    }
    return tiles;
}

fn strEqlReversed(a: []u8, b: []u8) bool {
    if (a.len != b.len) {
        return false;
    }
    for (a) |item, index| {
        if (item != b[(b.len - index - 1)]) {
            return false;
        }
    }
    return true;
}

fn part1(tiles: []Tile) usize {
    var ans: usize = 1;
    var i: usize = 0;
    while (i < tiles.len) : (i += 1) {
        var matched: usize = 0;
        {
            var k: usize = 0;
            while (k < 4) : (k += 1) {
                var edge_source = tiles[i].edges[k];
                outer: {
                    var j: usize = 0;
                    while (j < tiles.len) : (j += 1) {
                        if (i == j) {
                            continue;
                        }
                        {
                            var l: usize = 0;
                            while (l < 4) : (l += 1) {
                                var edge_target = tiles[j].edges[l];
                                if (std.mem.eql(u8, &edge_source, &edge_target) or strEqlReversed(&edge_source, &edge_target)) {
                                    matched += 1;
                                    break :outer;
                                }
                            }
                        }
                    }
                }
            }
        }
        if (matched == 2) {
            ans *= tiles[i].id;
        }
    }
    return ans;
}

pub fn main() !void {
    var input = utils.readFile("inputs/day20.txt");
    var tiles = parseTiles(input);
    print("{}\n", .{part1(tiles)});
}
