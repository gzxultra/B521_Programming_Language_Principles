#lang racket

;1
(define list-ref
  (lambda (ls n)
    (letrec
      ((nth-cdr
         (lambda (n)
			(if (zero? n) 
				ls
				(cdr (nth-cdr (sub1 n))))
           )))
      (car (nth-cdr n)))))
	  
;2
(define (union ls1 ls2)
	(cond
		((null? ls1) ls2)
		((memv (car ls1) ls2) (union (cdr ls1) ls2))
		(else (cons (car ls1) (union (cdr ls1) ls2)))))
		
;3
(define (extend x pred)
	(lambda (x2) (or (eqv? x2 x) (pred x2))))
	
;4			
(define (walk-symbol x s)
	(cond
		((assv x s)=>(lambda (p) 
						(let ((v (cdr p)))
							(if (symbol? v)
									(walk-symbol v s)
									v))))
		(else x)))
			
;5
(define (lambda->lumbda e)
	(match e
		((? symbol?) e)
		(`(lambda (,x) ,body) `(lumbda (,x) ,(lambda->lumbda body)))
		(`(,operator ,operand) `(,(lambda->lumbda operator) ,(lambda->lumbda operand)))))

;6
(define (var-occurs? var e)
	(match e
		((? symbol?) (eqv? e var))
		(`(lambda (,x) ,body) (var-occurs? var body))
		(`(,operator ,operand) (or (var-occurs? var operator) (var-occurs? var operand)))))

;7
(define (vars e)
	(match e
		((? symbol?) `(,e))
		(`(lambda (,x) ,body) (vars body))
		(`(,operator ,operand) (append (vars operator) (vars operand)))))
		
;8
(define (unique-vars e)
	(match e
		((? symbol?) `(,e))
		(`(lambda (,x) ,body) (unique-vars body))
		(`(,operator ,operand) (union (unique-vars operator) (unique-vars operand)))))

;9
(define (var-occurs-free? var e)
	(match e
		((? symbol?) (eqv? var e))
		(`(lambda (,x) ,body) (and (var-occurs? var e) (not (eqv? var x))))
		(`(,operator ,operand) (or (var-occurs-free? var operator) (var-occurs-free? var operand)))))

;10
(define (var-occurs-bound? var e)
	(match e
		((? symbol?) #f)
		(`(lambda (,x) ,body) (if (eqv? var x) (var-occurs? var body) (var-occurs-bound? var body))) 
		(`(,operator ,operand) (or (var-occurs-bound? var operator) (var-occurs-bound? var operand)))))

;11
(define (unique-free-vars e)
	(filter (lambda (x) (var-occurs-free? x e)) (unique-vars e)))
	
;12
(define (unique-bound-vars e)
	(filter (lambda (x) (var-occurs-bound? x e)) (unique-vars e)))
	
;13
(define (lex e acc)
	(match e
		((? symbol?) `(var ,(index-of acc e)))
		(`(lambda (,x) ,body) `(lambda ,(lex body (cons x acc))))
		(`(,operator ,operand) `(,(lex operator acc) ,(lex operand acc)))))

;14
(define (walk-symbol-update x s)
	(cond
		((assv x s)
			=>(lambda (p) 
				(let ((b (cdr p)))
					(cond
						((symbol? (unbox b))
							(set-box! b (walk-symbol-update (unbox b) s)) 
							(unbox b))
						(else 
							(unbox b))))))
		(else x)))

;15
(define (var-occurs-both? var e)
	(match e
		((? symbol?) 
			(values (eqv? var e) #f))
		(`(lambda (,x) ,body)
			(if (eqv? var x) 
					(values #f (var-occurs? var body))
					(var-occurs-both? var body)))
		(`(,operator ,operand) 
			(let-values 
				([(f1 b1) (var-occurs-both? var operator)]
				 [(f2 b2) (var-occurs-both? var operand)])
				(values (or f1 f2) (or b1 b2))))))
