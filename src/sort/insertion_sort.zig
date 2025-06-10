pub fn insertion_sort(comptime T: type, array: []T) void {
    if (array.len == 0) return;
    var buffer = array[0];
    for (array, 0..) |element, i| {
        buffer = element;
        var j = i;
        while (j > 0 and array[j - 1] > buffer) {
            array[j] = array[j - 1];
            j -= 1;
        }
        array[j] = buffer;
    }
}
const std = @import("std");
const testing = std.testing;

test "insertion_sort: empty array" {
    var arr = [_]i32{};
    insertion_sort(i32, &arr);
    try testing.expectEqualSlices(i32, &[_]i32{}, &arr);
}

test "insertion_sort: single element" {
    var arr = [_]i32{42};
    insertion_sort(i32, &arr);
    try testing.expectEqualSlices(i32, &[_]i32{42}, &arr);
}

test "insertion_sort: already sorted array" {
    var arr = [_]i32{ 1, 2, 3, 4, 5 };
    insertion_sort(i32, &arr);
    try testing.expectEqualSlices(i32, &[_]i32{ 1, 2, 3, 4, 5 }, &arr);
}

test "insertion_sort: reverse sorted array" {
    var arr = [_]i32{ 5, 4, 3, 2, 1 };
    insertion_sort(i32, &arr);
    try testing.expectEqualSlices(i32, &[_]i32{ 1, 2, 3, 4, 5 }, &arr);
}

test "insertion_sort: random unsorted array" {
    var arr = [_]i32{ 3, 1, 4, 1, 5, 9, 2, 6 };
    insertion_sort(i32, &arr);
    try testing.expectEqualSlices(i32, &[_]i32{ 1, 1, 2, 3, 4, 5, 6, 9 }, &arr);
}

test "insertion_sort: with duplicates" {
    var arr = [_]i32{ 7, 3, 7, 1, 3, 5 };
    insertion_sort(i32, &arr);
    try testing.expectEqualSlices(i32, &[_]i32{ 1, 3, 3, 5, 7, 7 }, &arr);
}

test "insertion_sort: floating-point numbers" {
    var arr = [_]f64{ 3.5, 1.2, 4.8, 1.2, 0.5 };
    insertion_sort(f64, &arr);
    try testing.expectEqualSlices(f64, &[_]f64{ 0.5, 1.2, 1.2, 3.5, 4.8 }, &arr);
}
