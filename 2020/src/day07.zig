const std = @import("std");
const print = std.debug.print;
const utils = @import("utils.zig");
const Bag = struct {
    quantity: usize,
    color: []const u8,
};
var container_re: utils.regex = undefined;
var content_re: utils.regex = undefined;
const BagList = std.ArrayList(Bag);
const StrBoolMap = std.StringHashMap(bool);
const StrUsizeMap = std.StringHashMap(usize);
const StrBagListMap = std.StringHashMap(BagList);
const CalcErrors = error{OutOfMemory};
fn calcHoldsShiny(rule_map: *StrBagListMap, shiny_map: *StrBoolMap, bag: []const u8) CalcErrors!bool {
    if (shiny_map.get(bag)) |result| return result;
    var result = false;
    for (rule_map.get(bag).?.items) |child_bag| {
        {
            const color = child_bag.color;
            if (utils.strEql(color, "shiny gold") or (try calcHoldsShiny(rule_map, shiny_map, color))) {
                result = true;
                break;
            }
        }
    }
    try shiny_map.put(bag, result);
    return result;
}

fn calcContainedBags(rule_map: *StrBagListMap, count_map: *StrUsizeMap, bag: []const u8) CalcErrors!usize {
    if (count_map.get(bag)) |result| return result;
    var contains: usize = 0;
    for (rule_map.get(bag).?.items) |child_bag| {
        {
            const color = child_bag.color;
            var count = (try calcContainedBags(rule_map, count_map, color));
            contains += (child_bag.quantity * (count + 1));
        }
    }
    try count_map.put(bag, contains);
    return contains;
}

pub fn main() !void {
    container_re = (try utils.regex.compile(std.testing.allocator, "(\\w+\\s+\\w+) bags contain (.*)"));
    content_re = (try utils.regex.compile(std.testing.allocator, "(\\d+)\\s+(\\w+\\s+\\w+)"));
    var lines = utils.readFileLines("inputs/day07.txt");
    var rules = StrBagListMap.init(std.testing.allocator);
    for (lines) |line| {
        if ((try container_re.captures(line))) |captures| {
            var bag_list = BagList.init(std.testing.allocator);
            var bag_it = std.mem.split(captures.sliceAt(2).?, ", ");
            while (bag_it.next()) |bag| {
                if ((try content_re.captures(bag))) |bag_captures| {
                    const b = Bag{
                        .color = bag_captures.sliceAt(2).?,
                        .quantity = utils.parseInt(usize, bag_captures.sliceAt(1).?),
                    };
                    try bag_list.append(b);
                }
            }
            try rules.put(captures.sliceAt(1).?, bag_list);
        }
    }
    var result: usize = 0;
    var shiny_map = StrBoolMap.init(std.testing.allocator);
    var it = rules.iterator();
    while (it.next()) |rule| {
        if ((try calcHoldsShiny(&rules, &shiny_map, rule.key))) {
            result += 1;
        }
    }
    print("{}\n", .{result});
    var count_map = StrUsizeMap.init(std.testing.allocator);
    print("{}\n", .{calcContainedBags(&rules, &count_map, "shiny gold")});
}
