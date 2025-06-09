const std = @import("std");
const expect = std.testing.expect;

pub fn bubble_sort(comptime T: type, array: []T) void {
    const length = array.len;
    if (length == 0) return;
    for (0..length - 1) |i| {
        var swapped = false;
        for (0..length - i - 1) |j| {
            if (array[j] > array[j + 1]) {
                const tmp = array[j];
                array[j] = array[j + 1];
                array[j + 1] = tmp;
                swapped = true;
            }
        }
        if (!swapped) break;
    }
}
test "empty array" {
    var arr: [0]i32 = undefined;
    bubble_sort(i32, &arr);
    try expect(arr.len == 0);
}

test "single element" {
    var arr = [_]i32{42};
    bubble_sort(i32, &arr);
    try expect(arr[0] == 42);
}

test "already sorted" {
    var arr = [_]i32{ 1, 2, 3, 4, 5 };
    bubble_sort(i32, &arr);
    try std.testing.expectEqualSlices(i32, &arr, &[_]i32{ 1, 2, 3, 4, 5 });
}

test "reverse sorted" {
    var arr = [_]i32{ 5, 4, 3, 2, 1 };
    bubble_sort(i32, &arr);
    try std.testing.expectEqualSlices(i32, &arr, &[_]i32{ 1, 2, 3, 4, 5 });
}

test "random array" {
    var arr = [_]i32{ 3, 1, 4, 1, 5, 9, 2, 6 };
    bubble_sort(i32, &arr);
    try std.testing.expectEqualSlices(i32, &arr, &[_]i32{ 1, 1, 2, 3, 4, 5, 6, 9 });
}
