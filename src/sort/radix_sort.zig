const std = @import("std");

// Вспомогательная функция для получения максимального числа в массиве
fn getMax(arr: []const u32) u32 {
    var max = arr[0];
    for (arr) |num| {
        if (num > max) {
            max = num;
        }
    }
    return max;
}

// Функция для выполнения сортировки подсчетом для определенного разряда
fn countingSort(arr: []u32, exp: u32, allocator: std.mem.Allocator) !void {
    const n = arr.len;
    var output = try allocator.alloc(u32, n);
    defer allocator.free(output);

    var count = [_]u32{0} ** 10;

    // Подсчет количества вхождений каждой цифры
    for (arr) |num| {
        const index = (num / exp) % 10;
        count[@as(usize, index)] += 1;
    }

    // Изменение count[i] так, чтобы он содержал фактическую позицию этой цифры в output
    var i: usize = 1;
    while (i < 10) : (i += 1) {
        count[i] += count[i - 1];
    }

    // Построение выходного массива
    var j = n;
    while (j > 0) {
        j -= 1;
        const num = arr[j];
        const index = (num / exp) % 10;
        output[count[@as(usize, index)] - 1] = num;
        count[@as(usize, index)] -= 1;
    }

    // Копирование отсортированного массива обратно в arr
    @memcpy(arr, output);
}

// Основная функция Radix Sort
pub fn radixSort(arr: []u32, allocator: std.mem.Allocator) !void {
    if (arr.len == 0) return;

    const max = getMax(arr);

    // Применение counting sort для каждого разряда
    var exp: u32 = 1;
    while (max / exp > 0) : (exp *= 10) {
        try countingSort(arr, exp, allocator);
    }
}

const testing = std.testing;

test "radixSort: empty array" {
    var arr = [_]u32{};
    try radixSort(&arr, testing.allocator);
    try testing.expectEqualSlices(u32, &[_]u32{}, &arr);
}

test "radixSort: single element" {
    var arr = [_]u32{42};
    try radixSort(&arr, testing.allocator);
    try testing.expectEqualSlices(u32, &[_]u32{42}, &arr);
}

test "radixSort: already sorted array" {
    var arr = [_]u32{ 10, 20, 30, 40, 50 };
    try radixSort(&arr, testing.allocator);
    try testing.expectEqualSlices(u32, &[_]u32{ 10, 20, 30, 40, 50 }, &arr);
}

test "radixSort: reverse sorted array" {
    var arr = [_]u32{ 50, 40, 30, 20, 10 };
    try radixSort(&arr, testing.allocator);
    try testing.expectEqualSlices(u32, &[_]u32{ 10, 20, 30, 40, 50 }, &arr);
}

test "radixSort: random unsorted array" {
    var arr = [_]u32{ 170, 45, 75, 90, 802, 24, 2, 66 };
    try radixSort(&arr, testing.allocator);
    try testing.expectEqualSlices(u32, &[_]u32{ 2, 24, 45, 66, 75, 90, 170, 802 }, &arr);
}

test "radixSort: array with duplicate values" {
    var arr = [_]u32{ 5, 2, 5, 1, 2, 1, 5 };
    try radixSort(&arr, testing.allocator);
    try testing.expectEqualSlices(u32, &[_]u32{ 1, 1, 2, 2, 5, 5, 5 }, &arr);
}

test "radixSort: large numbers" {
    var arr = [_]u32{ 1000000, 999999, 1000001, 999998 };
    try radixSort(&arr, testing.allocator);
    try testing.expectEqualSlices(u32, &[_]u32{ 999998, 999999, 1000000, 1000001 }, &arr);
}

test "radixSort: numbers with varying digit lengths" {
    var arr = [_]u32{ 1, 100, 10, 1000, 10000, 100, 1 };
    try radixSort(&arr, testing.allocator);
    try testing.expectEqualSlices(u32, &[_]u32{ 1, 1, 10, 100, 100, 1000, 10000 }, &arr);
}

test "radixSort: array with all zeros" {
    var arr = [_]u32{ 0, 0, 0, 0, 0 };
    try radixSort(&arr, testing.allocator);
    try testing.expectEqualSlices(u32, &[_]u32{ 0, 0, 0, 0, 0 }, &arr);
}

test "radixSort: array with single digit numbers" {
    var arr = [_]u32{ 9, 1, 5, 3, 7, 2, 8, 4, 6 };
    try radixSort(&arr, testing.allocator);
    try testing.expectEqualSlices(u32, &[_]u32{ 1, 2, 3, 4, 5, 6, 7, 8, 9 }, &arr);
}
