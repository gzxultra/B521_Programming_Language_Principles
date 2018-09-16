#lang racket

;1 & 5
(define (value-of e env)
	(match e
		(`,n #:when (number? n) n)
		(`,b #:when (boolean? b) b)
		(`,y #:when (symbol? y) (unbox (env y)))
		(`(if ,test ,then ,alt) (if (value-of test env)
										(value-of then env)
										(value-of alt env)))
		(`(zero? ,x) (eqv? (value-of x env) 0))
		(`(sub1 ,x) (sub1 (value-of x env)))
		(`(* ,x1 ,x2) (* (value-of x1 env) (value-of x2 env)))
		(`(set! ,v ,e) (set-box! (env v) (value-of e env)))
		(`(begin2 ,exp1 ,exp2) (begin (value-of exp1 env) (value-of exp2 env)))
		(`(let ((,x ,e)) ,body) (let ((be (box (value-of e env)))) (value-of body (lambda (y) (if (eqv? y x) be (env y))))))
		(`(lambda (,x) ,body) (lambda (arg) (let ((barg (box arg))) (value-of body (lambda (y) (if (eqv? y x) barg (env y)))))))
		(`(,operator ,operand) ((value-of operator env) (value-of operand env)))))

;2	
(define (empty-env-fn)
		(lambda (y) (error 'value-of-fn "unbound variable ~s" y)))
		
(define (value-of-fn e env)
	(define (apply-env env x)
		(env x))
	(define (ext-env env v e)
		(lambda (x) (if (eqv? x v) e (apply-env env x))))
	(match e
		(`,n #:when (number? n) n)
		(`,b #:when (boolean? b) b)
		(`,y #:when (symbol? y) (apply-env env y))
		(`(if ,test ,then ,alt) (if (value-of-fn test env)
										(value-of-fn then env)
										(value-of-fn alt env)))
		(`(zero? ,x) (eqv? (value-of-fn x env) 0))
		(`(sub1 ,x) (sub1 (value-of-fn x env)))
		(`(* ,x1 ,x2) (* (value-of-fn x1 env) (value-of-fn x2 env)))
		(`(let ((,x ,e)) ,body) (value-of-fn body (ext-env env x (value-of-fn e env))))
		(`(lambda (,x) ,body) (lambda (arg) (value-of-fn body (ext-env env x arg))))
		(`(,operator ,operand) ((value-of-fn operator env) (value-of-fn operand env)))))

;3
(define (empty-env-ds) '())
		
(define (value-of-ds e env)
	(define (apply-env env v)
		(cond
			((assv v env)=>(lambda (p) (cdr p)))
			(else (error 'value-of-fn "unbound variable ~s" v))))
	(define (ext-env env v e)
		(cons (cons v e) env))
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
		(`(let ((,x ,e)) ,body) (value-of-ds body (ext-env env x (value-of-ds e env))))
		(`(lambda (,x) ,body) (lambda (arg) (value-of-ds body (ext-env env x arg))))
		(`(,operator ,operand) ((value-of-ds operator env) (value-of-ds operand env)))))

;4
(define (empty-env)
		(lambda (y) (error 'fo-eulav "unbound variable ~s" y)))
(define (fo-eulav e env)
	(define (apply-env env x)
		(env x))
	(define (ext-env env v e)
		(lambda (x) (if (eqv? x v) e (apply-env env x))))
	(match e
		(`,n #:when (number? n) n)
		(`,b #:when (boolean? b) b)
		(`,y #:when (symbol? y) (apply-env env y))
		(`(,alt ,then ,test fi) (if (fo-eulav test env)
										(fo-eulav then env)
										(fo-eulav alt env)))
		(`(,x ?orez) (eqv? (fo-eulav x env) 0))
		(`(,x 1bus) (sub1 (fo-eulav x env)))
		(`(,x1 ,x2 *) (* (fo-eulav x1 env) (fo-eulav x2 env)))
		(`(,body (,x) adbmal) (lambda (arg) (fo-eulav body (ext-env env x arg))))
		(`(,operand ,operator) ((fo-eulav operator env) (fo-eulav operand env)))))
	  
;6
(define empty-env-lex 
  (lambda () '()))	

(define (extend-env-lex a env)
  (cons a env))

(define (apply-env-lex env num)
  (list-ref env num))
  
(define value-of-lex
  (lambda (exp env)
    (match exp
      [`(const ,expr) expr]
      [`(mult ,x1 ,x2) (* (value-of-lex x1 env) (value-of-lex x2 env))]
      [`(zero ,x) (zero? (value-of-lex x env))]
      (`(sub1 ,body) (sub1 (value-of-lex body env)))
      (`(if ,t ,c ,a) (if (value-of-lex t env) (value-of-lex c env) (value-of-lex a env)))
      (`(var ,num) (apply-env-lex env num))
      (`(lambda ,body) (lambda (a) (value-of-lex body (extend-env-lex a env))))
      (`(,rator ,rand) ((value-of-lex rator env) (value-of-lex rand env))))))
 
;7
;only have some idea, don't know if makes sense
;(define church-sub1 
;	(lambda (c) 
;		(lambda (f) 
;			(lambda (x) 
;				(unmark 
;					((c 
;					  (lambda (x2) 
;						(if (marked? x2) 
;								(mark (f (unmark x2))) 
;								(mark x2)))) 
;					 x)))))

