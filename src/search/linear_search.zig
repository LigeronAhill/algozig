const std = @import("std");
const testing = std.testing;

pub fn linear_search(comptime T: type, haystack: []T, needle: T) bool {
    for (haystack) |element| {
        if (element == needle) return true;
    }
    return false;
}

test "test linear_search works" {
    var hs = [_]i32{ 14, 33, 42, 12 };
    try testing.expect(linear_search(i32, &hs, 42));
}
test "test linear_search fails" {
    var hs = [_]i32{ 14, 33, 42, 12 };
    try testing.expect(!linear_search(i32, &hs, 43));
}
