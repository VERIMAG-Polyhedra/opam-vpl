Require Import VplTactic.Tactic.
Add Field Qcfield: Qcft (decidable Qc_eq_bool_correct, constants [vpl_cte]).

Lemma ex_intro (x: Qc) (f: Qc -> Qc):
  x <= 1
  -> (f x) < (f 1)
  -> x < 1.
Proof.
  vpl_auto.
Qed.

Goal forall (v1 v2 v3: Qc) (f: Qc -> Qc),
   f ((v2 - 1)*v3) <> f ((2#3) * v1 * v2)
   -> v1+3 <= (v2 + v3)
   -> v1 <= 3*(v3-v2-1)
   -> 2*v1 < 3*(v3-2).
Proof.
  vpl_reduce.
  vpl_post.
Qed.
