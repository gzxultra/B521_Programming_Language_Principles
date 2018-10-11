#lang racket

(define empty-k
  (lambda ()
    (let ((once-only #f))
      (lambda (v)
        (if once-only
	    (error 'empty-k "You can only invoke the empty continuation once")
	    (begin (set! once-only #t) v))))))

;1
(define (binary-to-decimal-cps n k)
	(cond
		((null? n) (k 0))
		(else (binary-to-decimal-cps (cdr n) (lambda (d) (k (+ (car n) (* 2 d))))))))

(define (binary-to-decimal n)
	(binary-to-decimal-cps n (empty-k)))

;2		
(define (times-cps ls k)
	(cond 
		((null? ls) (k 1))
		((zero? (car ls)) (k 0))
		(else (times-cps (cdr ls) (lambda (d) (k (* (car ls) d)))))))
		
(define (times ls)
	(times-cps ls (empty-k)))
		
;3
(define (times-cps-shortcut ls k)
	(cond
		((null? ls) (k 1))
		((zero? (car ls)) 0)
		(else (times-cps (cdr ls) (lambda (d) (k (* (car ls) d)))))))
		
(define (times-shortcut ls)
	(times-cps-shortcut ls (empty-k)))
	
;4
(define plus-cps
  (lambda (m k1)
    (k1 (lambda (n k2)
          (k2 (+ m n))))))
	
(define plus
	(lambda (m)
		(lambda (n)
			((plus-cps m (empty-k)) n (empty-k)))))
			
;5
(define (remv-first-9*-cps ls k)
	(cond
		((null? ls) '())
		((pair? (car ls))
			(cond
				((remv-first-9*-cps (car ls) (lambda (a) (equal? (car ls) a)))
				 (remv-first-9*-cps (cdr ls) (lambda (d) (k (cons (car ls) d)))))
				(else (remv-first-9*-cps (car ls) (lambda (a) (k (cons a (cdr ls))))))))
		((eqv? (car ls) '9) (k (cdr ls)))
		(else (remv-first-9*-cps (cdr ls) (lambda (d) (k (cons (car ls) d)))))))
		
(define (remv-first-9* ls)
	(remv-first-9*-cps ls (empty-k)))
		
;6
(define (cons-cell-count-cps ls k)
	(cond
		((pair? ls)
			(cons-cell-count-cps (car ls) (lambda (a) (cons-cell-count-cps (cdr ls) (lambda (d) (k (add1 (+ a d))))))))
		(else (k 0))))
		
(define (cons-cell-count ls)
	(cons-cell-count-cps ls (empty-k)))
		
;7
(define (find-cps u s k)
	(let ((pr (assv u s)))
		(if pr (find-cps (cdr pr) s k) 
			   (k u))))
	
(define (find u s)
	(find-cps u s (empty-k)))
	
;8	 
(define (ack-cps m n k)
	(cond
		((zero? m) (k (add1 n)))
		((zero? n) (ack-cps (sub1 m) 1 k))
		(else (ack-cps m (sub1 n) (lambda (r) (ack-cps (sub1 m) r k))))))
		
(define (ack m n)
	(ack-cps m n (empty-k)))
		
;9
(define (fib-cps n k)
	((lambda (fib k)
		(fib fib n k))
	(lambda (fib n k)
		(cond
			((zero? n) (k 0))
			((zero? (sub1 n)) (k 1))
			(else (fib fib (sub1 n) (lambda (r1) (fib fib (sub1 (sub1 n)) (lambda (r2) (k (+ r1 r2))))))))) k))
			
(define (fib n)
	(fib-cps n (empty-k)))
			
;10
(define (unfold-cps p f g seed k)
	((lambda (h)
		((h h) seed '() k))
	 (lambda (h)
		(lambda (seed ans k)
			(p seed (lambda (r)
                                  (if r
                                      (k ans)
                                      (f seed (lambda (r1) (g seed (lambda (r2) ((h h) r2 (cons r1 ans) k))))))))))))

(define (unfold p f g seed)
	(unfold-cps p f g seed (empty-k)))
	
(define null?-cps
    (lambda (ls k)
      (k (null? ls))))
(define car-cps
    (lambda (pr k)
      (k (car pr))))
(define cdr-cps
    (lambda (pr k)
      (k (cdr pr))))
				
;11
(define empty-s
  (lambda ()
    '()))

(define (unify-cps u v s k)
	(cond
		((eqv? u v) (k s))
		((number? u) (k (cons (cons u v) s)))
		((number? v) (unify-cps v u s k))
		((pair? u)
			(if (pair? v)
                            (find-cps (car u) s (lambda (r1)
                             (find-cps (car v) s (lambda (r2)
                              (unify-cps r1 r2 s (lambda (r3)
                               (if r3
                               (find-cps (cdr u) r3 (lambda (r4)
                                (find-cps (cdr v) r3 (lambda (r5)
                                 (unify-cps r4 r5 r3 (lambda (r6)
                                  (k r6))))))) #f)))))))
			#f))
		(else #f)))

(define (unify u v s)
	(unify-cps u v s (empty-k)))
		
;12		
(define M-cps
	(lambda (f k)
          (k (lambda (ls k)
			(cond
				((null? ls) (k '()))
				(else (M-cps f (lambda (r2) (f (car ls) (lambda (r1) (cons r1 (r2 (cdr ls) k))))))))))))

;13				
(define use-of-M-cps
	((M-cps (lambda (n k) (k (add1 n))) (empty-k)) '(1 2 3 4 5) (empty-k)))
	
;14
(define (strange-cps x k)
	((lambda (g k) (lambda (x k) (g g k)))
	 (lambda (g k) (lambda (x k) (g g k))) k))
	 
	 
;15
(define use-of-strange-cps
  (let ((strange^ (strange-cps 5 (lambda (r1)
                            (r1 6 (lambda (r2)
                             (r2 7 (empty-k))))))))
    (strange^ 8 (lambda (r3)
           (r3 9 (lambda (r4)
           (r4 10 (empty-k))))))))

;16
(define why-cps
  (lambda (f k)
    ((lambda (h) (h h k))
     (lambda (g k) (f (lambda (x k) (g g (lambda (r) (r x k)))) k)))))
