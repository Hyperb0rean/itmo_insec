import math
from functools import wraps

N = 81177745546021
e = 2711039
C = '''
61553353723258
11339642237403
55951185642146
38561524032018
34517298669793
33641624424571
78428225355946
50176820404544
68017840453091
5507834749606
26675763943141
47457759065088
'''

def memoize(func):
    cache = {}
    
    @wraps(func)
    def wrapper(*args):
        if args not in cache:
            cache[args] = func(*args)
        return cache[args]
    
    return wrapper

@memoize
def find_sqrt_w(n, N, i=0):
    i += 1
    t = n + i
    w = t ** 2 - N
    
    if w < 0:
        return None
    
    sqrt_w = math.sqrt(w)
    
    if sqrt_w % 1 == 0:
        return (t, int(sqrt_w))
    else:
        return find_sqrt_w(n, N, i)


def decrypt(N, e, C):
    print(f"N = {N}")
    print(f"e = {e}")
    print(f"C = {C}")

    message = ""

    n = int(math.sqrt(N) // 1 + 1)
    print(f"n = [sqrt(N)] + 1 = {n}")

    t, sqrt_w = find_sqrt_w(n, N)
    p = t + sqrt_w
    q = t - sqrt_w
    phi = round((p - 1) * (q - 1))
    d = pow(e, -1, phi)

    print(f"p = t + sqrt(w) = {t} + {sqrt_w} = {p}")
    print(f"q = t - sqrt(w) = {t} - {sqrt_w} = {q}")
    print(f"Phi(N) = (p - 1) * (q - 1) = ({p - 1}) * ({q - 1}) = {phi}")
    print(f"d = e^(-1) mod Phi(N) = {e}^(-1) mod {phi} = {d}", "\n")

    for i, c in enumerate(C.split()):
        m = pow(int(c), d, N)
        part = m.to_bytes(4, byteorder='big').decode('cp1251')
        message += part
    print(f"message = {message}")


decrypt(N, e, C)