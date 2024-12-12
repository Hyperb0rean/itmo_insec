from typing import NamedTuple , TypeVar , Generic
from sympy import isprime , FiniteField , GF

F = GF ( mod = 751)
P : int = F . mod


class Point ( NamedTuple ) :
    x: F
    y: F

class EllipticCurve ( NamedTuple ) :
    a: F
    b: F

def add ( self , lhs : Point , rhs : Point ) -> Point :
    ( x1 , y1 ) , ( x2 , y2 ) = lhs , rhs

    lmbd = (
        ( y2 - y1 ) / ( x2 - x1 ) if x1 != x2
        else (3 * x1 ** 2 + self . a ) / (2 * y1 )
    )
    assert 0 <= int ( lmbd ) < P

    x3 = lmbd ** 2 - x1 - x2
    y3 = lmbd * ( x1 - x3 ) - y1

    return Point ( x3 , y3 )

def rev ( self , point : Point ) -> Point :
    return Point ( point .x , - point . y )

def sub ( self , lhs : Point , rhs : Point ) -> Point :
    return self . add ( lhs , self . rev ( rhs ) )

def pow ( self , point : Point , n : int ) -> Point :
    assert 0 < n
    return point if n == 1 else self . add ( point , self . pow ( point , n - 1) )

def __contains__ ( self , point : Point ) -> bool :
    a , b = self
    x , y = point
    return y ** 2 == x ** 3 + a * x + b

class Chiper ( NamedTuple ) :
    c1 : Point
    c2 : Point

E = EllipticCurve ( a = F ( -1) , b = F (1) )

(a , b ) = E
assert isprime ( P ) and P not in (2 , 3)
assert 4 * a ** 3 + 27 * b ** 2 != 0

M2P = {
    "о": Point(F(240), F(309)),
    "т": Point(F(247), F(366)),
    "с": Point(F(243), F(664)),
    "л": Point(F(237), F(454)),
    "у": Point(F(247), F(485)),
    "ж": Point(F(235), F(19)),
    "и": Point(F(236), F(39)),
    "т": Point(F(247), F(266)),
    "ь": Point(F(256), F(121)),
}

P2M = { point : ch for ch , point in M2P . items () }

# for _ , point in M2P . items () :
#     assert point in E

M = "отслужить"
PUB = Point ( F (16) , F (416) ) ; assert PUB in E
K = [2 , 8 , 4 , 2 , 6 , 10 , 3 , 3 , 18]
G = Point ( F (0) , F (1) )
assert E . pow (G , 3) == Point (56 , 419)


def encrypt_atom ( ch : str , k : int ) -> Chiper :
    assert len ( ch ) == 1
    c1 = E . pow (G , k )
    c2 = E . add ( M2P [ ch ] , E . pow ( PUB , k ) )
    return Chiper ( c1 , c2 )

def decrypt_atom ( chiper : Chiper ) -> str :
    ( c1 , c2 ) = chiper
    return P2M [ E . sub ( c2 , E . pow ( c1 , SEC ) ) ]

def encrypt ( text : str , k : list [ int ]) -> list [ Chiper ]:
    return [ encrypt_atom ( ch , k [ i ]) for i , ch in enumerate ( text ) ]

def decrypt ( chiper : list [ Chiper ]) -> str :
    return ' '. join ( map ( decrypt_atom , chiper ) )

SEC = next ( filter ( lambda i : E . pow (G , i ) == PUB , range (1 , P ) ) ) ; SEC
assert decrypt ( encrypt (M , K ) ) == M

print ( " \ n " . join ( repr ( _ ) for _ in encrypt (M , K ) ) )