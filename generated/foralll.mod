module foralll.

typeOf (absT R2) (all R) :- (pi x\ typeOf (R2 x) (R x)).

typeOf (appT E X) (R X) :- typeOf E (all R).

step (appT (absT R2) X) (R2 X).

value (absT R1).

step (appT E1 T2) (appT E1' T2) :- step E1 E1'.

nstep E E.

nstep E1 E3 :- step E1 E2, nstep E2 E3.

