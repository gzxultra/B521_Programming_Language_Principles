#lang racket
;1
(define (filter-sps p? ls store)
		(cond
			((null? ls) (values '() '()))
			(else 
				(let-values 
					(((r s) (filter-sps p? (cdr ls) store))) 
						(if (p? (car ls)) (values (cons (car ls) r) s)
										  (values r (cons (car ls) s)))))))
					
					
(define (filter*-sps p? ls store)
	(if (null? ls) 
			(values '() '())
			(let-values (((r s) (filter*-sps p? (cdr ls) store)))
				(cond
					((pair? (car ls))
						(let-values (((r2 s2) (filter*-sps p? (car ls) '())))
							(values (cons r2 r) (cons s2 s))))
					((p? (car ls)) (values (cons (car ls) r) s))
					(else (values r (cons (car ls) s)))))))

;2					
(define (fib-sps n store)
	(cond
		((= n 0) (values 0 '((0 . 0))))
		((= n 1) (values 1 '((1 . 1))))
		((assv n store)=>(lambda (p) (values (cdr p) store)))
		(else
			(let-values (((r2 s2) (fib-sps (- n 2) store)))
				(let-values (((r1 s1) (fib-sps (- n 1) s2)))
					(values (+ r1 r2) (cons `(,n . ,(+ r1 r2)) s1)))))))

;3			
(define-syntax and*
	(syntax-rules ()
		((and*) #t)
		((and* a) a)
		((and* a b ...) (if a (and* b ...) #f))))

;4
(define-syntax list*
	(syntax-rules ()
		((list* a) a)
		((list* a b ...) (cons a (list* b ...)))))

;5		
(define-syntax macro-list
	(syntax-rules ()
		((macro-list) '())
		((macro-list a b ...) (cons a (macro-list b ...)))))

;6
(define-syntax mcond
  (syntax-rules (else)
    ((mcond) (void))
    ((mcond (else e)) e)
    ((mcond (c e) rest ...) (if c e (mcond rest ...)))))
	
;7 is this cheating?
(define-syntax macro-map
	(syntax-rules ()
		((macro-map macro '()) '())
		((macro-map macro '(a b ...)) (cons (macro a) (macro-map macro '(b ...))))))