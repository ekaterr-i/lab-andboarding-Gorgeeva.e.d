Данный ассемблерный код вычисляет сумму чисел от 1 до 10 включительно (\(1 + 2 + 3 + ... + 10 = 55\)).
def calculate_sum():
    total = 0
    i = 1
    while i <= 10:
        total += i
        i += 1
    return total
