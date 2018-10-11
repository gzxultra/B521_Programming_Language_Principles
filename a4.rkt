#lang racket

;1
(define (lex e acc)
	(match e
		(`,n #:when (number? n) `(const ,n))
		(`(zero? ,x) `(zero? ,(lex x acc)))
		(`(sub1 ,x) `(sub1 ,(lex x acc)))
		(`(* ,e1 ,e2) `(* ,(lex e1 acc) ,(lex e2 acc)))
		(`(if ,c ,t ,f) `(if ,(lex c acc) ,(lex t acc) ,(lex f acc)))
		(`(let ((,x ,e)) ,body) `(let ,(lex e acc) ,(lex body (cons x acc))))
		((? symbol?) `(var ,(index-of acc e)))
		(`(lambda (,x) ,body) `(lambda ,(lex body (cons x acc))))
		(`(,operator ,operand) `(,(lex operator acc) ,(lex operand acc)))))
		
;2
(define (empty-env) 
	(make-immutable-hasheqv))

(define (apply-env env v)
	(hash-ref env v))
			
(define (ext-env env v e)
	(hash-set env v e))
		
(define (closure-ds body x env) 
	`(,body ,x ,env))

(define (apply-closure-ds closure x)
	(match closure
		(`(,body ,fp ,env) (value-of-ds body (ext-env env fp x)))))

(define (value-of-ds e env)
	(match e
		(`,n #:when (number? n) n)
		(`,b #:when (boolean? b) b)
		(`,y #:when (symbol? y) (apply-env env y))
		(`(if ,test ,then ,alt) (if (value-of-ds test env)
										(value-of-ds then env)
										(value-of-ds alt env)))
		(`(zero? ,x) (eqv? (value-of-ds x env) 0))
		(`(sub1 ,x) (sub1 (value-of-ds x env)))
		(`(* ,x1 ,x2) (* (value-of-ds x1 env) (value-of-ds x2 env)))
		(`(let ((,x ,e)) ,body) (let ((arg (value-of-ds e env))) (value-of-ds body (ext-env env x arg))))
		(`(lambda (,x) ,body) (closure-ds body x env))
		(`(,operator ,operand) (apply-closure-ds (value-of-ds operator env) (value-of-ds operand env)))))
		
;3
(define (value-of-dynamic e env)
	(match e
		(`,n #:when (number? n) n)
		(`,b #:when (boolean? b) b)
		(`(quote ,v) v)
		(`,y #:when (symbol? y) (apply-env env y))
		(`(if ,test ,then ,alt) (if (value-of-dynamic test env)
										(value-of-dynamic then env)
										(value-of-dynamic alt env)))
		(`(null? ,x) (null? (value-of-dynamic x env)))
		(`(zero? ,x) (eqv? (value-of-dynamic x env) 0))
		(`(car ,x) (car (value-of-dynamic x env)))
		(`(cdr ,x) (cdr (value-of-dynamic x env)))
		(`(cons ,a ,b) (cons (value-of-dynamic a env) (value-of-dynamic b env)))
		(`(sub1 ,x) (sub1 (value-of-dynamic x env)))
		(`(* ,x1 ,x2) (* (value-of-dynamic x1 env) (value-of-dynamic x2 env)))
		(`(let ((,x ,e)) ,body) (let ((arg (value-of-dynamic e env))) (value-of-dynamic body (ext-env env x arg))))
		(`(lambda (,x) ,body) `(lambda (,x) ,body))
		(`(,operator ,operand) (match operator 
									(`(lambda (,x) ,body) (value-of-dynamic body (ext-env env x operand)))
									(else (value-of-dynamic `(,(value-of-dynamic operator env) ,(value-of-dynamic operand env)) env))))))
									
;4
(define (value-of-ri empty-env ext-env apply-env closure apply-closure)
	(letrec ((value-of
		(lambda (e env)
			(match e
				(`,n #:when (number? n) n)
				(`,b #:when (boolean? b) b)
				(`,y #:when (symbol? y) (apply-env env y))
				(`(if ,test ,then ,alt) (if (value-of test env)
												(value-of then env)
												(value-of alt env)))
				(`(zero? ,x) (eqv? (value-of x env) 0))
				(`(sub1 ,x) (sub1 (value-of x env)))
				(`(* ,x1 ,x2) (* (value-of x1 env) (value-of x2 env)))
				(`(let ((,x ,e)) ,body) (let ((arg (value-of e env))) (value-of body (ext-env x arg env))))
				(`(lambda (,x) ,body) (closure body x env value-of ext-env))
				(`(,operator ,operand) (apply-closure (value-of operator env) (value-of operand env) value-of ext-env))))))
			(lambda (e) (value-of e empty-env))))

(define (closure-fn-ri body x env valof ext-env) 
	(lambda (arg) (valof body (ext-env x arg env))))
(define (apply-closure-fn-ri closure a valof ext-env) (closure a))
	
(define (closure-ds-ri body x env valof ext-env) `(,body ,x ,env))
(define (apply-closure-ds-ri closure a valof ext-env)
	(match closure (`(,body ,fp ,env) (valof body (ext-env fp a env)))))

(define (empty-env-fn y) (error "unbound id" y))
(define (extend-env-fn x a env)	(λ (y) (if (eqv? y x) a (apply-env-fn env y))))
(define (apply-env-fn env y) (env y))

(define empty-env-ds (make-immutable-hasheqv))
(define (extend-env-ds x a env) (hash-set env x a))
(define (apply-env-ds env y) (hash-ref env y))