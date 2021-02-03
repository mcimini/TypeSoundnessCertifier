module stlc_natural_recursor.

typeOf (abs T1 R) (arrow T1 T2) :- (pi x\ typeOf x T1 => typeOf (R x) T2).

typeOf (succ E) (int ) :- typeOf E (int ).

typeOf (zero ) (int ).

typeOf (ff ) (bool ).

typeOf (tt ) (bool ).

typeOf (cons E1 E2) (list T) :- typeOf E1 T, typeOf E2 (list T).

typeOf (emptyList ) (list T).

typeOf (app E1 E2) T2 :- typeOf E1 (arrow T1 T2), typeOf E2 T1.

step (app (abs T1 R) V) (R V) :- value V.

typeOf (natrec E1 E2 E3) (int ) :- typeOf E1 (int ), typeOf E2 (int ), typeOf E3 (arrow (int ) (arrow (int ) (int ))).

step (natrec (zero ) V1 V2) V1 :- value V1, value V2.

step (natrec (succ E) V2 V3) (app (app V3 E) (natrec E V2 V3)) :- value E, value V2, value V3.

typeOf (pred E') (int ) :- typeOf E' (int ).

step (pred (zero )) (myerror ).

step (pred (succ E)) E.

typeOf (isZero E') (bool ) :- typeOf E' (int ).

step (isZero (zero )) (tt ).

step (isZero (succ E)) (ff ).

typeOf (if E1 E2 E3) T :- typeOf E1 (bool ), typeOf E2 T, typeOf E3 T.

step (if (tt ) E1 E2) E1.

step (if (ff ) E1 E2) E2.

typeOf (head E) T :- typeOf E (list T).

step (head (emptyList )) (myerror ).

step (head (cons E1 E2)) E1.

typeOf (tail E) (list T) :- typeOf E (list T).

step (tail (emptyList )) (myerror ).

step (tail (cons E1 E2)) E2.

typeOf (letrec T1 R1 R2) T2 :- (pi x\ typeOf x T1 => typeOf (R1 x) T1), (pi x\ typeOf x T1 => typeOf (R2 x) T2).

step (letrec T1 R1 R2) (R2 (fix (abs T1 R1))).

typeOf (fix E) T :- typeOf E (arrow T T).

step (fix E) (app E (fix E)) :- value E.

typeOf (let E R) T2 :- typeOf E T1, (pi x\ typeOf x T1 => typeOf (R x) T2).

step (let V R) (R V) :- value V.

value (abs T1 R2).

value (succ E1) :- value E1.

value (zero ).

value (ff ).

value (tt ).

value (cons E1 E2) :- value E1, value E2.

value (emptyList ).

step (succ E1) (succ E1') :- step E1 E1'.

step (cons E1 E2) (cons E1' E2) :- step E1 E1'.

step (cons E1 E2) (cons E1 E2') :- step E2 E2', value E1.

step (app E1 E2) (app E1' E2) :- step E1 E1'.

step (app E1 E2) (app E1 E2') :- step E2 E2', value E1.

step (natrec E1 E2 E3) (natrec E1' E2 E3) :- step E1 E1'.

step (natrec E1 E2 E3) (natrec E1 E2' E3) :- step E2 E2', value E1.

step (natrec E1 E2 E3) (natrec E1 E2 E3') :- step E3 E3', value E1, value E2.

step (pred E1) (pred E1') :- step E1 E1'.

step (isZero E1) (isZero E1') :- step E1 E1'.

step (if E1 E2 E3) (if E1' E2 E3) :- step E1 E1'.

step (head E1) (head E1') :- step E1 E1'.

step (tail E1) (tail E1') :- step E1 E1'.

step (fix E1) (fix E1') :- step E1 E1'.

step (let E1 R2) (let E1' R2) :- step E1 E1'.

error (myerror ).

typeOf (myerror ) T.

step (succ E1) E1 :- error E1.

step (cons E1 E2) E1 :- error E1.

step (cons E1 E2) E2 :- error E2.

step (app E1 E2) E1 :- error E1.

step (app E1 E2) E2 :- error E2.

step (natrec E1 E2 E3) E1 :- error E1.

step (natrec E1 E2 E3) E2 :- error E2.

step (natrec E1 E2 E3) E3 :- error E3.

step (pred E1) E1 :- error E1.

step (isZero E1) E1 :- error E1.

step (if E1 E2 E3) E1 :- error E1.

step (head E1) E1 :- error E1.

step (tail E1) E1 :- error E1.

step (fix E1) E1 :- error E1.

step (let E1 R2) E1 :- error E1.

nstep E E.

nstep E1 E3 :- step E1 E2, nstep E2 E3.

