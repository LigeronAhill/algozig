//! By convention, root.zig is the root source file when making a library. If
//! you are making an executable, the convention is to delete this file and
//! start with main.zig instead.
const std = @import("std");
var _ = @import("fibonacci.zig");
const testing = std.testing;
const sort = @import("sort/sort.zig");

pub export fn add(a: i32, b: i32) i32 {
    return a + b;
}

test "basic add functionality" {
    _ = sort;
    try testing.expect(add(3, 7) == 10);
}
