const std = @import("std");
const print = std.debug.print;
const utils = @import("utils.zig");
const InstructionType = enum {
    Acc,
    Jmp,
    Nop,
};
const Instruction = struct {
    inst: InstructionType,
    val: isize,
};
pub fn interpret(instructions: []const Instruction) isize {
    var visited = utils.alloc(bool, instructions.len);
    var i: usize = 0;
    while (i < instructions.len) : (i += 1) {
        visited[i] = false;
    }
    var pc: usize = 0;
    var acc: isize = 0;
    while (true) {
        if (pc >= instructions.len) {
            break;
        }
        if (visited[pc]) {
            break;
        }
        visited[pc] = true;
        var inst = instructions[pc];
        var inst_type = inst.inst;
        var val = inst.val;
        switch (inst_type) {
            .Acc => {
                acc += val;
                pc += 1;
            },
            .Jmp => pc = @intCast(usize, @intCast(isize, pc) + val),
            .Nop => pc += 1,
        }
    }
    return acc;
}

pub fn checkTerminates(instructions: []const Instruction) bool {
    var visited = utils.alloc(bool, instructions.len);
    var i: usize = 0;
    while (i < instructions.len) : (i += 1) {
        visited[i] = false;
    }
    var pc: usize = 0;
    var acc: isize = 0;
    while (true) {
        if (pc >= instructions.len) {
            return true;
        }
        if (visited[pc]) {
            return false;
        }
        visited[pc] = true;
        var inst = instructions[pc];
        var inst_type = inst.inst;
        var val = inst.val;
        switch (inst_type) {
            .Acc => {
                acc += val;
                pc += 1;
            },
            .Jmp => pc = @intCast(usize, @intCast(isize, pc) + val),
            .Nop => pc += 1,
        }
    }
}

pub fn flipInst(inst: *Instruction) void {
    switch (inst.inst) {
        .Jmp => inst.inst = .Nop,
        .Nop => inst.inst = .Jmp,
        .Acc => {},
    }
}

pub fn main() void {
    var lines = utils.readFileLines("inputs/day08.txt");
    var instructions = utils.alloc(Instruction, lines.len);
    var i: usize = 0;
    while (i < lines.len) : (i += 1) {
        var line = lines[i];
        var inst_str = line[0..3];
        var inst = if (utils.strEql("acc", inst_str)) InstructionType.Acc else if (utils.strEql("jmp", inst_str)) InstructionType.Jmp else if (utils.strEql("nop", inst_str)) InstructionType.Nop else if (true) undefined;
        instructions[i].inst = inst;
        var sign: i2 = if ('+' == line[4..5][0]) 1 else -1;
        instructions[i].val = sign * utils.parseInt(isize, line[5..]);
    }
    print("{}\n", .{interpret(instructions)});
    i = 0;
    while (i < instructions.len) : (i += 1) {
        flipInst(&instructions[i]);
        if (checkTerminates(instructions)) {
            print("{}\n", .{interpret(instructions)});
            return;
        }
        flipInst(&instructions[i]);
    }
}
