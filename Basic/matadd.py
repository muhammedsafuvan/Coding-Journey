N = int(input())
array = []
for i in range(N):
    row = []
    for j in range(N):
        row.append(int(input()))
    array.append(row)

for i in range(N):
    for j in range(N):
        print(array[i][j], end= " ")
    print()


