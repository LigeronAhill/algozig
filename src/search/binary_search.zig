const std = @import("std");
const expect = std.testing.expect;

pub fn binary_search(comptime T: type, haystack: []const T, needle: T) ?usize {
    if (haystack.len == 0) return null;
    var left: usize = 0;
    var right = haystack.len - 1;
    while (left <= right) {
        const mid = left + (right - left) / 2;
        if (haystack[mid] == needle) return mid;
        if (haystack[mid] < needle) left = mid + 1;
        if (haystack[mid] > needle) right = mid - 1;
    }
    return null;
}
pub fn binary_search_first(comptime T: type, haystack: []const T, needle: T) ?usize {
    if (haystack.len == 0) return null;

    var left: usize = 0;
    var right: usize = haystack.len;

    while (left < right) {
        const mid = left + (right - left) / 2;
        if (haystack[mid] < needle) {
            left = mid + 1;
        } else {
            right = mid;
        }
    }

    return if (left < haystack.len and haystack[left] == needle) left else null;
}

pub fn binary_search_last(comptime T: type, haystack: []const T, needle: T) ?usize {
    if (haystack.len == 0) return null;

    var left: usize = 0;
    var right: usize = haystack.len;

    while (left < right) {
        const mid = left + (right - left) / 2;
        if (haystack[mid] > needle) {
            right = mid;
        } else {
            left = mid + 1;
        }
    }

    return if (left > 0 and haystack[left - 1] == needle) left - 1 else null;
}

test "test binary_search works" {
    var hs = [_]i32{ -10, -5, 4, 6, 8, 10, 11, 20, 100 };
    try expect(binary_search(i32, &hs, 10) == 5);
}
test "test linear_search fails" {
    var hs = [_]i32{ -10, -5, 4, 6, 8, 10, 11, 20, 100 };
    try expect(binary_search(i32, &hs, 12) == null);
}
test "empty array" {
    var hs = [_]u8{};
    try expect(binary_search(u8, &hs, 42) == null);
}

test "single element" {
    var hs = [_]u8{42};
    try expect(binary_search(u8, &hs, 42) == 0);
    try expect(binary_search(u8, &hs, 100) == null);
}
test "binary_search_first" {
    const empty = [_]i32{};
    try expect(binary_search_first(i32, &empty, 42) == null);

    const single = [_]i32{42};
    try expect(binary_search_first(i32, &single, 42) == 0);
    try expect(binary_search_first(i32, &single, 100) == null);

    const dup = [_]i32{ 1, 2, 2, 2, 3 };
    try expect(binary_search_first(i32, &dup, 2) == 1);
    try expect(binary_search_first(i32, &dup, 4) == null);

    const all_same = [_]i32{ 5, 5, 5 };
    try expect(binary_search_first(i32, &all_same, 5) == 0);
}
test "binary_search_last - empty array" {
    const empty = [_]i32{};
    try expect(binary_search_last(i32, &empty, 42) == null);
}

test "binary_search_last - single element" {
    const single = [_]i32{42};
    try expect(binary_search_last(i32, &single, 42) == 0);
    try expect(binary_search_last(i32, &single, 100) == null);
}

test "binary_search_last - no duplicates" {
    const arr = [_]i32{ 1, 3, 5, 7, 9 };
    try expect(binary_search_last(i32, &arr, 5) == 2);
    try expect(binary_search_last(i32, &arr, 4) == null);
}

test "binary_search_last - with duplicates" {
    const dup = [_]i32{ 1, 2, 2, 2, 3, 3, 4 };
    try expect(binary_search_last(i32, &dup, 2) == 3);
    try expect(binary_search_last(i32, &dup, 3) == 5);
    try expect(binary_search_last(i32, &dup, 5) == null);
}

test "binary_search_last - all same elements" {
    const all_same = [_]i32{ 5, 5, 5 };
    try expect(binary_search_last(i32, &all_same, 5) == 2);
    try expect(binary_search_last(i32, &all_same, 3) == null);
}

test "binary_search_last - first and last" {
    const arr = [_]i32{ 1, 2, 3, 4, 5 };
    try expect(binary_search_last(i32, &arr, 1) == 0);
    try expect(binary_search_last(i32, &arr, 5) == 4);
}
