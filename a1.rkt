#lang racket

;1
(define countdown
	(lambda (n)
		(if (zero? n) 
			'(0)
			(cons n (countdown (sub1 n))))))

;2		
(define insertR
	(lambda (s1 s2 l)
		(cond 
			((null? l) '())
			((eqv? (car l) s1) (cons s1 (cons s2 (insertR s1 s2 (cdr l)))))
			(else (cons (car l) (insertR s1 s2 (cdr l)))))))

;3		
(define remv-1st
	(lambda (s l)
		(cond
			((null? l) '())
			((eqv? (car l) s) (cdr l))
			(else (cons (car l) (remv-1st s (cdr l)))))))

;4		
(define list-index-ofv?
	(lambda (e l)
		(if (eqv? e (car l)) 
			0
			(add1 (list-index-ofv? e (cdr l))))))		

;5		
(define filter
	(lambda (p? l)
		(cond
			((null? l) '())
			((p? (car l)) (cons (car l) (filter p? (cdr l))))
			(else (filter p? (cdr l))))))

;6		
(define zip
	(lambda (l1 l2)
		(if (or (null? l1) (null? l2)) 
			'()
			(cons (cons (car l1) (car l2)) (zip (cdr l1) (cdr l2))))))
		
;7
(define map
	(lambda (p ls)
		(if (null? ls) 
			'()
			(cons (p (car ls)) (map p (cdr ls))))))
		
;8
(define append
	(lambda (ls1 ls2)
		(if (null? ls1) 
			ls2
			(cons (car ls1) (append (cdr ls1) ls2)))))
		
;9
(define reverse
	(lambda (l)
		(if (null? l) 
			'()
			(append (reverse (cdr l)) (cons (car l) '())))))
		
;10
(define fact
	(lambda (n)
		(if (zero? n)
			1
			(* n (fact (sub1 n))))))

;11
(define memv
	(lambda (e l)
		(cond
			((null? l) #f)
			((eqv? e (car l)) l)
			(else (memv e (cdr l))))))

;12
(define fib
	(lambda (n)
		(cond
			((= n 0) 0)
			((= n 1) 1)
			(else (+ (fib (- n 2)) (fib (- n 1)))))))
		
;13
'((w . (x . ())) . (y . ((z . ()) . ())))

;14
(define binary->natural
	(lambda (b)
		(if (null? b)
			0
			(+ (car b) (* 2 (binary->natural (cdr b)))))))
		
;15
(define minus
	(lambda (n1 n2)
		(if (zero? n2)
			n1
			(minus (sub1 n1) (sub1 n2)))))
		
;16
(define div
	(lambda (n1 n2)
		(if (= n1 0)
			0
			(add1 (div (- n1 n2) n2)))))
		
;17
(define append-map
	(lambda (p ls)
		(if (null? ls)
			'()
			(append (p (car ls)) (append-map p (cdr ls))))))

;18
(define set-difference
	(lambda (s1 s2)
		(cond
			((null? s1) '())
			((memv (car s1) s2) (set-difference (cdr s1) s2))
			(else (cons (car s1) (set-difference (cdr s1) s2))))))
		
;19
(define powerset
	(lambda (s)
		(if (null? s) 
			'(())
			(append 
				(map 
					(lambda (l) 
						(cons (car s) l)) 
					(powerset (cdr s))) 
				(powerset (cdr s))))))
	
;20
;in my DrRacket(v7.0, Windows version), if define and run this function both in REPL
;I have to define the function twice to get the right answer
;that is, define once and overlap it by defining it again(using exactly the same code)
;otherwise it acts strange, for example (cartesian-product '((1 2) (3 4))) becomes '((1 (3 4)) (2 (3 4)))

;just to record a confusing thing, could it because of the order of evaluation?

(define cartesian-product
	(lambda (sl)
		(if (null? sl)
			'(())
			(append-map 
				(lambda (x) 
					(map 
						(lambda (p) 
							(cons x p)) 
						(cartesian-product (cdr sl)))) 
				(car sl)))))
			
;21
(define insertR-fr
	(lambda (s1 s2 l)
		(foldr 
			(lambda (e result) 
				(if (eqv? e s1) 
					(cons e (cons s2 result)) 
					(cons e result))) 
			'() 
			l)))
		
(define filter-fr
	(lambda (p? l)
		(foldr 
			(lambda (e result) 
				(if (p? e) 
					(cons e result) 
					result)) 
			'() 
			l)))
		
(define map-fr
	(lambda (p ls)
		(foldr
			(lambda (e result)
				(cons (p e) result))
			'()
			ls)))
		
(define append-fr
	(lambda (ls1 ls2) (foldr cons ls2 ls1)))
	
(define reverse-fr
	(lambda (l)
		(foldr 
			(lambda (e result) 
				(append result (list e))) 
			'() 
			l)))

(define binary->natural-fr
	(lambda (b)
		(foldr 
			(lambda (e result) 
				(+ e (* 2 result))) 
			0 
			b)))
		
(define append-map-fr
	(lambda (p ls)
		(foldr
			(lambda (e result)
				(append (p e) result))
			'()
			ls)))
		
(define set-difference-fr
	(lambda (s1 s2)
		(foldr
			(lambda (e result)
				(if (memv e s2) result (cons e result)))
			'()
			s1)))

(define powerset-fr
	(lambda (s)
		(foldr
			(lambda (e result)
				(append (map (lambda (x) (cons e x)) result) result))
			'(())
			s)))
		
(define cartesian-product-fr
	(lambda (sl)
		(foldr
			(lambda (e result)
				(append-map 
					(lambda (x) 
						(map 
							(lambda (p) (cons x p)) 
							result)) 
					e))
			'(())
			sl)))
		
;22
(define collatz
  (letrec
    ((odd-case
       (lambda (recur)
         (lambda (x)
           (cond 
            ((and (positive? x) (odd? x)) (collatz (add1 (* x 3)))) 
            (else (recur x))))))
     (even-case
       (lambda (recur)
         (lambda (x)
           (cond 
            ((and (positive? x) (even? x)) (collatz (/ x 2))) 
            (else (recur x))))))
     (one-case
       (lambda (recur)
         (lambda (x)
           (cond
            ((zero? (sub1 x)) 1)
            (else (recur x))))))
     (base
       (lambda (x)
         (error 'error "Invalid value ~s~n" x))))
     (one-case (odd-case (even-case base)))
    ))
	