const std = @import("std");
const testing = std.testing;

/// Counting Sort (сортировка подсчётом).
/// Работает только для целых чисел
/// Не подходит для больших диапазонов (например, с разбросом в миллиарды).
pub fn counting_sort(array: []usize) !void {
    if (array.len == 0) return; // Пустой массив — не сортируем

    // Находим min и max
    var min: usize = array[0];
    var max: usize = array[0];
    for (array) |x| {
        if (x < min) min = x;
        if (x > max) max = x;
    }

    const range: usize = max - min + 1;
    if (range > 1_000_000) {
        return error.RangeTooLarge; // Защита от слишком больших диапазонов
    }

    // Создаём массив подсчёта и заполняем нулями
    var count = try std.heap.page_allocator.alloc(usize, range);
    defer std.heap.page_allocator.free(count);
    @memset(count, 0);

    // Подсчитываем количество каждого элемента
    for (array) |x| {
        const index = x - min;
        count[index] += 1;
    }

    // Заполняем исходный массив отсортированными значениями
    var i: usize = 0;
    for (0..range) |j| {
        const value = j + min;
        while (count[j] > 0) {
            array[i] = value;
            i += 1;
            count[j] -= 1;
        }
    }
}
test "counting_sort: empty array" {
    var arr = [_]usize{};
    try counting_sort(&arr);
    try testing.expectEqualSlices(usize, &[_]usize{}, &arr);
}

test "counting_sort: single element" {
    var arr = [_]usize{42};
    try counting_sort(&arr);
    try testing.expectEqualSlices(usize, &[_]usize{42}, &arr);
}

test "counting_sort: already sorted array" {
    var arr = [_]usize{ 1, 2, 3, 4, 5 };
    try counting_sort(&arr);
    try testing.expectEqualSlices(usize, &[_]usize{ 1, 2, 3, 4, 5 }, &arr);
}

test "counting_sort: reverse sorted array" {
    var arr = [_]usize{ 5, 4, 3, 2, 1 };
    try counting_sort(&arr);
    try testing.expectEqualSlices(usize, &[_]usize{ 1, 2, 3, 4, 5 }, &arr);
}

test "counting_sort: random unsorted array" {
    var arr = [_]usize{ 3, 1, 4, 1, 5, 9, 2, 6 };
    try counting_sort(&arr);
    try testing.expectEqualSlices(usize, &[_]usize{ 1, 1, 2, 3, 4, 5, 6, 9 }, &arr);
}

test "counting_sort: with duplicates" {
    var arr = [_]usize{ 7, 3, 7, 1, 3, 5 };
    try counting_sort(&arr);
    try testing.expectEqualSlices(usize, &[_]usize{ 1, 3, 3, 5, 7, 7 }, &arr);
}

test "counting_sort: range too large" {
    var arr = [_]usize{ 0, 1_000_001 };
    try testing.expectError(error.RangeTooLarge, counting_sort(&arr));
}
