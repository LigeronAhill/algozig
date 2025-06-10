const std = @import("std");
const testing = std.testing;

pub fn selection_sort(comptime T: type, array: []T) void {
    for (0..array.len) |i| {
        var min_index = i;

        for (i + 1..array.len) |j| {
            if (array[j] < array[min_index]) {
                min_index = j;
            }
        }

        if (min_index != i) {
            const temp = array[i];
            array[i] = array[min_index];
            array[min_index] = temp;
        }
    }
}

test "selection_sort: empty array" {
    var array: [0]i32 = undefined;
    selection_sort(i32, &array);
    try testing.expectEqualSlices(i32, &array, &[_]i32{});
}

test "selection_sort: single element" {
    var array = [_]i32{42};
    selection_sort(i32, &array);
    try testing.expectEqualSlices(i32, &array, &[_]i32{42});
}

test "selection_sort: already sorted array" {
    var array = [_]i32{ 1, 2, 3, 4, 5 };
    selection_sort(i32, &array);
    try testing.expectEqualSlices(i32, &array, &[_]i32{ 1, 2, 3, 4, 5 });
}

test "selection_sort: reverse sorted array" {
    var array = [_]i32{ 5, 4, 3, 2, 1 };
    selection_sort(i32, &array);
    try testing.expectEqualSlices(i32, &array, &[_]i32{ 1, 2, 3, 4, 5 });
}

test "selection_sort: random array" {
    var array = [_]i32{ 3, 1, 4, 1, 5, 9, 2, 6 };
    selection_sort(i32, &array);
    try testing.expectEqualSlices(i32, &array, &[_]i32{ 1, 1, 2, 3, 4, 5, 6, 9 });
}

test "selection_sort: with duplicates" {
    var array = [_]i32{ 2, 2, 1, 1, 3, 3 };
    selection_sort(i32, &array);
    try testing.expectEqualSlices(i32, &array, &[_]i32{ 1, 1, 2, 2, 3, 3 });
}

test "selection_sort: with negative numbers" {
    var array = [_]i32{ -3, -1, -2, 0, 2, 1 };
    selection_sort(i32, &array);
    try testing.expectEqualSlices(i32, &array, &[_]i32{ -3, -2, -1, 0, 1, 2 });
}
