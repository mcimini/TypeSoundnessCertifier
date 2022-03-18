module stlc_par_iff_natrec.

typeOf (natrec E1 E2 E3) (int ) :- typeOf E1 (int ), typeOf E2 (int ), typeOf E3 (arrow (int ) (arrow (int ) (int ))).

step (natrec (zero ) V1 V2) V1 :- value V1, value V2.

step (natrec (succ V1) V2 V3) (app (app V3 V1) (natrec V1 V2 V3)) :- value V1, value V2, value V3.

typeOf (abs T1 R) (arrow T1 T2) :- (pi x\ typeOf x T1 => typeOf (R x) T2).

typeOf (tt ) (bool ).

typeOf (ff ) (bool ).

typeOf (app E1 E2) T2 :- typeOf E1 (arrow T1 T2), typeOf E2 T1.

step (app (abs T R) E) (R E).

typeOf (if E1 E2 E3) T :- typeOf E1 (bool ), typeOf E2 T, typeOf E3 T.

step (if (tt ) E1 E2) E1.

step (if (ff ) E1 E2) E2.

value (abs T1 R2).

value (tt ).

value (ff ).


% context app C e.
% context app e C.
% context if C e e.
% context natrec C e e.
% context natrec v C e.
% context natrec v v C.
