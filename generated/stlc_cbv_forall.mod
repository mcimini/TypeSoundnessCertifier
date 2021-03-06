module stlc_cbv_forall.

typeOf (abs T1 R) (arrow T1 T2) :- (pi x\ typeOf x T1 => typeOf (R x) T2).

typeOf (absT R2) (all R) :- (pi x\ typeOf (R2 x) (R x)).

typeOf (app E1 E2) T2 :- typeOf E1 (arrow T1 T2), typeOf E2 T1.

step (app (abs T1 R) V) (R V) :- value V.

typeOf (appT E X) (R X) :- typeOf E (all R).

step (appT (absT R2) X) (R2 X).

value (abs T1 R2).

value (absT R1).

step (app E1 E2) (app E1' E2) :- step E1 E1'.

step (app E1 E2) (app E1 E2') :- step E2 E2', value E1.

step (appT E1 T2) (appT E1' T2) :- step E1 E1'.

nstep E E.

nstep E1 E3 :- step E1 E2, nstep E2 E3.

