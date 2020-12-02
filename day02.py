import re

inp = []

with open('inputs/2.txt') as f:
    for line in f:
        inp.append(line.strip())

reg = re.compile(r'^(\d+)-(\d+) (.): (\w+)$')

passes = []

for thing in inp:
    m = reg.search(thing)
    passes.append(m.groups())

# print(passes)
c1 = 0
c2 = 0
for p in passes:
    (low, high, letter, password) = p
    low = int(low)
    high = int(high)
    count = len(password.split(letter)) - 1
    if count <= high and count >= low:
        c1 += 1

    matches = 0
    try:
        if password[low - 1] == letter:
            matches += 1
        if password[high - 1] == letter:
            matches += 1
    except:
        pass
    if matches == 1:
        c2 += 1

print(c1)
print(c2)
