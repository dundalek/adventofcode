const std = @import("std");
const print = std.debug.print;
const utils = @import("utils.zig");
const Passport = struct {
    byr: ?[]const u8,
    iyr: ?[]const u8,
    eyr: ?[]const u8,
    hgt: ?[]const u8,
    hcl: ?[]const u8,
    ecl: ?[]const u8,
    pid: ?[]const u8,
};
pub fn setField(p: *Passport, k: []const u8, v: []const u8) void {
    if (utils.strEql(k, "byr")) p.byr = v else if (utils.strEql(k, "iyr")) p.iyr = v else if (utils.strEql(k, "eyr")) p.eyr = v else if (utils.strEql(k, "hgt")) p.hgt = v else if (utils.strEql(k, "hcl")) p.hcl = v else if (utils.strEql(k, "ecl")) p.ecl = v else if (utils.strEql(k, "pid")) p.pid = v;
}

pub fn hasAllFields(p: *Passport) bool {
    return ((p.byr != null) and (p.iyr != null) and (p.eyr != null) and (p.hgt != null) and (p.hcl != null) and (p.ecl != null) and (p.pid != null));
}

pub fn isValidNumber(s: []const u8, min: usize, max: usize) bool {
    var n = utils.parseInt(usize, s);
    return ((min <= n) and (n <= max));
}

pub fn reMatch(re: *utils.regex, s: []const u8, len: usize) bool {
    return ((s.len == len) and re.match(s)) catch |_| {
        unreachable;
    };
}

pub fn isValid(p: *Passport) bool {
    var m = hgt_re.captures(p.hgt.?) catch |_| {
        unreachable;
    };
    return ((m != null) and ((utils.strEql(m.?.sliceAt(2).?, "cm") and isValidNumber(m.?.sliceAt(1).?, 150, 193)) or (utils.strEql(m.?.sliceAt(2).?, "in") and isValidNumber(m.?.sliceAt(1).?, 59, 76))) and isValidNumber(p.byr.?, 1920, 2002) and isValidNumber(p.iyr.?, 2010, 2020) and isValidNumber(p.eyr.?, 2020, 2030) and reMatch(&hcl_re, p.hcl.?, 7) and reMatch(&ecl_re, p.ecl.?, 3) and reMatch(&pid_re, p.pid.?, 9));
}

var hgt_re: utils.regex = undefined;
var hcl_re: utils.regex = undefined;
var ecl_re: utils.regex = undefined;
var pid_re: utils.regex = undefined;
pub fn main() !void {
    hgt_re = (try utils.regex.compile(std.heap.page_allocator, "(\\d+)(cm|in)"));
    hcl_re = (try utils.regex.compile(std.heap.page_allocator, "#[0-9a-f]{6}"));
    ecl_re = (try utils.regex.compile(std.heap.page_allocator, "amb|blu|brn|gry|grn|hzl|oth"));
    pid_re = (try utils.regex.compile(std.heap.page_allocator, "\\d{9}"));
    const input = utils.readFile("inputs/day04.txt");
    var it = std.mem.split(input, "\n\n");
    var complete_count: usize = 0;
    var valid_count: usize = 0;
    while (it.next()) |passport| {
        var p = Passport{
            .ecl = null,
            .byr = null,
            .iyr = null,
            .hgt = null,
            .pid = null,
            .hcl = null,
            .eyr = null,
        };
        var token_it = std.mem.tokenize(passport, " :\n");
        while (token_it.next()) |key| {
            setField(&p, key, token_it.next().?);
        }
        if (!hasAllFields(&p)) {
            continue;
        }
        complete_count += 1;
        if (isValid(&p)) {
            valid_count += 1;
        }
    }
    print("{}\n", .{complete_count});
    print("{}\n", .{valid_count});
}
