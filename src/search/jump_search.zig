const std = @import("std");
const math = std.math;
const expect = std.testing.expect;

pub fn jump_search(comptime T: type, haystack: []const T, needle: T) ?usize {
    if (haystack.len == 0) return null;
    const l: f64 = @floatFromInt(haystack.len);
    const r: f64 = @ceil(@sqrt(l));
    const block_size: usize = @intFromFloat(r);
    var start: usize = 0;
    var end: usize = block_size - 1;

    while (end < haystack.len and haystack[end] < needle) {
        start = end + 1;
        end += block_size;
    }

    end = @min(end, haystack.len - 1);

    if (start >= haystack.len or haystack[start] > needle) {
        return null;
    }
    if (haystack[start] > needle or haystack[end] < needle) {
        return null;
    }

    var i = end;
    while (i >= start) : (i -= 1) {
        if (haystack[i] == needle) return i;
        if (i == 0) break;
    }

    return null;
}
test "jump_search - empty array" {
    const empty = [_]i32{};
    try expect(jump_search(i32, &empty, 42) == null);
}

test "jump_search - single element" {
    const single = [_]i32{42};
    try expect(jump_search(i32, &single, 42) == 0);
    try expect(jump_search(i32, &single, 100) == null);
}

test "jump_search - multiple elements" {
    const arr = [_]i32{ 1, 3, 5, 7, 9, 11, 13 };
    try expect(jump_search(i32, &arr, 7) == 3);
    try expect(jump_search(i32, &arr, 13) == 6);
    try expect(jump_search(i32, &arr, 1) == 0);
}

test "jump_search - not found" {
    const arr = [_]i32{ 2, 4, 6, 8, 10 };
    try expect(jump_search(i32, &arr, 5) == null);
    try expect(jump_search(i32, &arr, 1) == null);
    try expect(jump_search(i32, &arr, 11) == null);
}

test "jump_search - duplicates" {
    const dup = [_]i32{ 1, 2, 2, 2, 3, 3, 4 };
    try expect(jump_search(i32, &dup, 2) == 2);
    try expect(jump_search(i32, &dup, 3) == 5);
}

test "jump_search - large array" {
    var large: [1000]i32 = undefined;
    for (&large, 0..) |*item, i| {
        item.* = @intCast(i * 2);
    }
    try expect(jump_search(i32, &large, 500) == 250);
    try expect(jump_search(i32, &large, 999) == null);
}
