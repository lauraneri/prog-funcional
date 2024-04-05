def eh_primo(n):
    if n <= 1:
        return False
    return all(n % i != 0 for i in range(2, int(n**0.5) + 1))

def encontrar_primos_no_intervalo(x, y):
    return filter(eh_primo, range(x, y + 1))

def pares_consecutivos(iteravel):
    primeiro, segundo = iteravel
    return zip(primeiro, segundo)

def comprimento_intervalo(par):
    primeiro, segundo = par
    return segundo - primeiro

def comprimento_maximo_intervalo(primos):
    pares = pares_consecutivos((primos, primos[1:]))
    comprimentos = map(comprimento_intervalo, pares)
    return max(comprimentos, default=0)

x = int(input())
y = int(input())

if x < y:
    primos = list(encontrar_primos_no_intervalo(x, y))
    if primos:
        print(comprimento_maximo_intervalo(primos))
