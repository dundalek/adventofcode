const std = @import("std");
const print = std.debug.print;
const utils = @import("utils.zig");
const floor = '.';
const empty = 'L';
const occupied = '#';
fn inBounds(seats: [][]const u8, row: isize, column: isize) bool {
    return if ((row < 0) or (column < 0) or (@intCast(usize, row) >= seats.len) or (column >= seats[@intCast(usize, row)].len)) false else true;
}

fn getNeighboursOccupancy(seats: [][]const u8, row: usize, column: usize) usize {
    var y: usize = if (0 < row) row - 1 else 0;
    var occupancy: usize = 0;
    while (y <= (row + 1)) : (y += 1) {
        var x: usize = if (0 < column) column - 1 else 0;
        while (x <= (column + 1)) : (x += 1) {
            if (!((y == row) and (x == column))) {
                var tmp: usize = if (inBounds(seats, @intCast(isize, y), @intCast(isize, x)) and (occupied == seats[y][x])) 1 else 0;
                occupancy += tmp;
            }
        }
    }
    return occupancy;
}

fn getTotalOccupancy(seats: [][]const u8) usize {
    var occupancy: usize = 0;
    var y: usize = 0;
    while (y < seats.len) : (y += 1) {
        var x: usize = 0;
        while (x < seats[y].len) : (x += 1) {
            var tmp: usize = if (occupied == seats[y][x]) 1 else 0;
            occupancy += tmp;
        }
    }
    return occupancy;
}

fn iteration1(source: [][]const u8, target: *[][]u8) usize {
    var moved_seats: usize = 0;
    var y: usize = 0;
    while (y < source.len) : (y += 1) {
        var x: usize = 0;
        while (x < source[y].len) : (x += 1) {
            var seat = source[y][x];
            if ((seat == empty) and (getNeighboursOccupancy(source, y, x) == 0)) {
                moved_seats += 1;
                target.*[y][x] = occupied;
            } else if ((seat == occupied) and (4 <= getNeighboursOccupancy(source, y, x))) {
                moved_seats += 1;
                target.*[y][x] = empty;
            } else if (true) target.*[y][x] = source[y][x];
        }
    }
    return moved_seats;
}

fn getDirectionalOccupancy(seats: [][]const u8, row: usize, column: usize, dy: isize, dx: isize) usize {
    var y = @intCast(isize, row);
    var x = @intCast(isize, column);
    while (true) {
        y += dy;
        x += dx;
        if (!inBounds(seats, y, x)) return 0 else if (occupied == seats[@intCast(usize, y)][@intCast(usize, x)]) return 1 else if (empty == seats[@intCast(usize, y)][@intCast(usize, x)]) return 0;
    }
}

fn getDirectionalNeighboursOccupancy(seats: [][]const u8, row: usize, column: usize) usize {
    var y: isize = -1;
    var occupancy: usize = 0;
    while (y <= 1) : (y += 1) {
        var x: isize = -1;
        while (x <= 1) : (x += 1) {
            if (!((y == 0) and (x == 0))) {
                occupancy += getDirectionalOccupancy(seats, row, column, y, x);
            }
        }
    }
    return occupancy;
}

fn iteration2(source: [][]const u8, target: *[][]u8) usize {
    var moved_seats: usize = 0;
    var y: usize = 0;
    while (y < source.len) : (y += 1) {
        var x: usize = 0;
        while (x < source[y].len) : (x += 1) {
            var seat = source[y][x];
            if ((seat == empty) and (getDirectionalNeighboursOccupancy(source, y, x) == 0)) {
                moved_seats += 1;
                target.*[y][x] = occupied;
            } else if ((seat == occupied) and (5 <= getDirectionalNeighboursOccupancy(source, y, x))) {
                moved_seats += 1;
                target.*[y][x] = empty;
            } else if (true) target.*[y][x] = source[y][x];
        }
    }
    return moved_seats;
}

fn printSeats(seats: [][]const u8) void {
    var occupancy: usize = 0;
    var y: usize = 0;
    while (y < seats.len) : (y += 1) {
        var x: usize = 0;
        while (x < seats[y].len) : (x += 1) {
            print("{c}", .{seats[y][x]});
        }
        print("\n", .{});
    }
}

fn part1() usize {
    var buf1 = @ptrCast(*[][]u8, &utils.readFileLines("inputs/day11.txt"));
    var buf2 = @ptrCast(*[][]u8, &utils.readFileLines("inputs/day11.txt"));
    var i: usize = 0;
    while (true) {
        i += 1;
        if (iteration1(buf1.*, buf2) == 0) {
            return getTotalOccupancy(buf1.*);
        }
        var tmp = buf1;
        buf1 = buf2;
        buf2 = tmp;
    }
}

fn part2() usize {
    var buf1 = @ptrCast(*[][]u8, &utils.readFileLines("inputs/day11.txt"));
    var buf2 = @ptrCast(*[][]u8, &utils.readFileLines("inputs/day11.txt"));
    var i: usize = 0;
    while (true) {
        i += 1;
        if (iteration2(buf1.*, buf2) == 0) {
            return getTotalOccupancy(buf1.*);
        }
        var tmp = buf1;
        buf1 = buf2;
        buf2 = tmp;
    }
}

pub fn main() void {
    print("{}\n", .{part1()});
    print("{}\n", .{part2()});
}
