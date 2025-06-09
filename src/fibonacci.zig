const std = @import("std");
const testing = std.testing;

pub fn fibonacci(num: u32) u32 {
    if (num < 2) return num;
    var a: u32 = 0;
    var b: u32 = 1;
    var i: u32 = 2;

    while (i <= num) : (i += 1) {
        const c = a + b;
        a = b;
        b = c;
    }

    return b;
}

test "test fibonacci works" {
    try testing.expect(fibonacci(5) == 5);
    try testing.expect(fibonacci(10) == 55);
}
test "test fibonacci fails" {
    try testing.expect(fibonacci(5) != 3);
}
