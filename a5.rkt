#lang racket
(define (empty-env)
		(lambda (y) (error "unbound variable ~s" y)))

(define (val-of-cbv exp env)
  (define (apply-env env a)
		  (env a))
  (define (ext-env env k v)
		  (lambda (arg) (if (eqv? arg k) v (env arg))))
  (define (make-closure x body env)
		  (lambda (arg) (let ((barg (box arg))) (val-of-cbv body (ext-env env x barg)))))
  (define (apply-closure clos x)
		  (clos x))
    (match exp
      [`(quote ()) '()]
      [`,b #:when (boolean? b) b]
      [`,n #:when (number? n)  n]
      [`(zero? ,n) (zero? (val-of-cbv n env))]
      [`(null? ,n) (null? (val-of-cbv n env))]
      [`(add1 ,n) (add1 (val-of-cbv n env))]
      [`(sub1 ,n) (sub1 (val-of-cbv n env))]
      [`(* ,n1 ,n2) (* (val-of-cbv n1 env) (val-of-cbv n2 env))]
      [`(set! ,x ,v) (set-box! (apply-env env x) (val-of-cbv v env))]
      [`(cons^ ,a ,d) (cons (lambda () (val-of-cbv a env)) (lambda () (val-of-cbv d env)))]
      [`(car^ ,ll) ((car (val-of-cbv ll env)))]
      [`(cdr^ ,ll) ((cdr (val-of-cbv ll env)))]
      [`(cons ,a ,d) (cons (val-of-cbv a env) (val-of-cbv d env))]
      [`(car ,l) (car (val-of-cbv l env))]
      [`(cdr ,l) (cdr (val-of-cbv l env))]
      [`(if ,test ,conseq ,alt) (if (val-of-cbv test env)
                                  (val-of-cbv conseq env)
                                  (val-of-cbv alt env))]
      [`(begin2 ,e1 ,e2) (begin (val-of-cbv e1 env) (val-of-cbv e2 env))]
      [`(random ,n) (random (val-of-cbv n env))]
      [`,y #:when (symbol? y) (unbox (apply-env env y))]
      [`(let ((,x ,e)) ,body) (let ((v (box (val-of-cbv e env)))) (val-of-cbv body (ext-env env x v)))]
      [`(lambda (,x) ,body) (make-closure x body env)]
      [`(,rator ,rand) (apply-closure (val-of-cbv rator env)
                                      (val-of-cbv rand env))]))
									  

(define (val-of-cbr exp env)
  (define (apply-env env a)
		  (env a))
  (define (ext-env env k v)
		  (lambda (arg) (if (eqv? k arg) v (env arg))))
  (define (make-closure x body env)
		  (lambda (arg) (val-of-cbr body (ext-env env x arg))))
  (define (apply-closure clos x)
		  (clos x))
    (match exp
      [`,b #:when (boolean? b) b]
      [`,n #:when (number? n)  n]
      [`(zero? ,n) (zero? (val-of-cbr n env))]
      [`(sub1 ,n) (sub1 (val-of-cbr n env))]
      [`(* ,n1 ,n2) (* (val-of-cbr n1 env) (val-of-cbr n2 env))]
      [`(set! ,x ,a) (set-box! (apply-env env x) (val-of-cbr a env))]
      [`(if ,test ,conseq ,alt) (if (val-of-cbr test env)
                                  (val-of-cbr conseq env)
                                  (val-of-cbr alt env))]
      [`(begin2 ,e1 ,e2) (begin (val-of-cbr e1 env) (val-of-cbr e2 env))]
      [`(random ,n) (random (val-of-cbr n env))]
      [`,y #:when (symbol? y) (unbox (apply-env env y))]
      [`(lambda (,x) ,body) (make-closure x body env)]
      [`(,rator ,x) #:when (symbol? x) (apply-closure (val-of-cbr rator env) (apply-env env x))]
      [`(,rator ,rand) (apply-closure (val-of-cbr rator env)
                                      (box (val-of-cbr rand env)))]))
									  
(define (val-of-cbname exp env)
  (define (apply-env env a)
		  (env a))
  (define (ext-env env k v)
		  (lambda (arg) (if (eqv? k arg) v (env arg))))
  (define (make-closure x body env)
		  (lambda (arg) (val-of-cbname body (ext-env env x arg))))
  (define (apply-closure clos x)
		  (clos x))
    (match exp
      [`,b #:when (boolean? b) b]
      [`,n #:when (number? n)  n]
      [`(zero? ,n) (zero? (val-of-cbname n env))]
      [`(sub1 ,n) (sub1 (val-of-cbname n env))]
      [`(* ,n1 ,n2) (* (val-of-cbname n1 env) (val-of-cbname n2 env))]
      [`(if ,test ,conseq ,alt) (if (val-of-cbname test env)
                                  (val-of-cbname conseq env)
                                  (val-of-cbname alt env))]
      [`(begin2 ,e1 ,e2) (begin (val-of-cbname e1 env) (val-of-cbname e2 env))]
      [`(random ,n) (random (val-of-cbname n env))]
      [`,y #:when (symbol? y) ((apply-env env y))]
      [`(lambda (,x) ,body) (make-closure x body env)]
      [`(,rator ,x) #:when (symbol? x) (apply-closure (val-of-cbname rator env) (apply-env env x))]
      [`(,rator ,rand) (apply-closure (val-of-cbname rator env)
                                      (lambda () (val-of-cbname rand env)))]))
									  
(define (val-of-cbneed exp env)
  (define (apply-env env a)
		  (env a))
  (define (ext-env env k v)
		  (lambda (arg) (if (eqv? k arg) v (env arg))))
  (define (make-closure x body env)
		  (lambda (arg) (val-of-cbneed body (ext-env env x arg))))
  (define (apply-closure clos x)
		  (clos x))
    (match exp
      [`,b #:when (boolean? b) b]
      [`,n #:when (number? n)  n]
      [`(zero? ,n) (zero? (val-of-cbneed n env))]
      [`(sub1 ,n) (sub1 (val-of-cbneed n env))]
      [`(* ,n1 ,n2) (* (val-of-cbneed n1 env) (val-of-cbneed n2 env))]
      [`(if ,test ,conseq ,alt) (if (val-of-cbneed test env)
                                  (val-of-cbneed conseq env)
                                  (val-of-cbneed alt env))]
      [`(begin2 ,e1 ,e2) (begin (val-of-cbneed e1 env) (val-of-cbneed e2 env))]
      [`(random ,n) (random (val-of-cbneed n env))]
      [`,y #:when (symbol? y) (let* ((b (apply-env env y)) (v ((unbox b)))) (begin (set-box! b (lambda () v)) v))]
      [`(lambda (,x) ,body) (make-closure x body env)]
      [`(,rator ,x) #:when (symbol? x) (apply-closure (val-of-cbneed rator env) (apply-env env x))]
      [`(,rator ,rand) (apply-closure (val-of-cbneed rator env)
                                      (box (lambda () (val-of-cbneed rand env))))]))