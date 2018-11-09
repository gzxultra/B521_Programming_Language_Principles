#lang racket
(require "mk.rkt")
(require "numbers.rkt")
;;↑It's an ALU! Amazing!↑


;; Part I Write the answers to the following problems using your
;; knowledge of miniKanren.  For each problem, explain how miniKanren
;; arrived at the answer.  You will be graded on the quality of your
;; explanation; a full explanation will require several sentences.

;; 1 What is the value of 

(run 2 (q)
  (== 5 q)
  (conde
   [(conde 
     [(== 5 q)
      (== 6 q)])
    (== 5 q)]
   [(== q 5)]))

;;It returns all the values of q that satisfy:
;;(q=5 and (((q=5 or q=6) or q=5) or 5=q)).
;;The only q that satisfy that is 5
;;so it returns a set with one element which is 5. 

;; 2 What is the value of
(run 1 (q) 
  (fresh (a b) 
    (== `(,a ,b) q)
    (absento 'tag q)
    (symbolo a)))

;;The solver finds all the q of form `(,a ,b)
;;in which a is a symbol 'tag does not occur in q,
;;so it returns ((_0 _1)) where _0 and _1 can
;;represent any symbol; but if add an constraint
;;that a or b == 'tag then it'll return an empty set.

;; 3 What do the following miniKanren constraints mean?
;; a ==
;; b =/=
;; c absento
;; d numbero
;; e symbolo

;;a:== unifies terms,which let the solver
;;search for the substitutions that
;;make the two terms equal.

;;b:=/= means the disequality constraint
;;between the terms, stating that the
;;terms cannot be equal in any situation.

;;c:(absento u v) makes sure that
;;term u does not occur in term v

;;d,e: numbero and symbolo makes sure that
;;the term satisfy the predicates
;;number? and symbol? in Scheme.

;; Part II goes here.

(defrel (assoco x ls q)
	(fresh (a d aa da)
		(== `(,a . ,d) ls)
		(== `(,aa . ,da) a)
		(conde
			((== aa x) (== q a))
			((=/= aa x) (assoco x d q)))))

(defrel (reverseo ls q)
	(conde
		((== '() ls) (== q '()))
		((=/= '() ls)
		 (fresh (a d res)
			(== ls `(,a . ,d))
                        (reverseo d res)
			(appendo res `(,a) q)))))

(defrel (stuttero ls q)
	(conde
		((== '() ls) (== q '()))
		((=/= '() ls)
		 (fresh (a d res)
			(== ls `(,a . ,d))
			(== q `(,a ,a . ,res))
			(stuttero d res)))))

(defrel (lengtho ls q)
	(conde
		((== '() ls) (== q (build-num 0)))
		((=/= '() ls)
		 (fresh (a d res)
			(== ls `(,a . ,d))
			(lengtho d res)
			(pluso res (build-num 1) q)))))