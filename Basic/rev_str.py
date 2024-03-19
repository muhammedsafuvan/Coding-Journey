def reverse_string(s):
    ans = []
    for i in range(len(s)-1,-1,-1):
        ans += s[i]
    return str(ans)

s = input("enter :")
print(reverse_string(s))
