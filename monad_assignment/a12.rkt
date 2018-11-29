#lang racket
(require "monads.rkt")

;1 Maybe monad
(define (findf-maybe p ls)
  (cond
    ((null? ls) (Nothing))
    ((p (car ls)) (Just (car ls)))
    (else (bind-maybe (findf-maybe p (cdr ls)) Just))))

;2 Writer monad
(define (partition-writer p ls)
  (cond
    ((null? ls)
     (inj-writer '()))
    ((not (p (car ls))) ; expected result in test suite and webpage is different; this follows the webpage
     (bind-writer (tell (car ls))
                  (lambda (_) (partition-writer p (cdr ls)))))
    (else
     (bind-writer (partition-writer p (cdr ls))
                  (lambda (d) (inj-writer (cons (car ls) d)))))))

;3 Writer monad
(define (powerXpartials x n)
  (cond
    ((zero? n) (inj-writer 1))
    ((zero? (sub1 n)) (inj-writer x))
    ((odd? n)
     (bind-writer (powerXpartials x (sub1 n))
                  (lambda (r)
                    (bind-writer
                     (tell r)
                     (lambda (_) (inj-writer (* x r)))))))
    ((even? n)
     (bind-writer (powerXpartials x (/ n 2))
                  (lambda (r)
                    (bind-writer
                     (tell r)
                     (lambda (_) (inj-writer (* r r)))))))))

;4 State monad
(define (replace-with-count x tree)
  (cond
    ((null? tree) (inj-state '()))
    ((eqv? x tree)
     (bind-state
      (get)
      (lambda (c)
        (bind-state
         (put (add1 c))
         (lambda (_) (inj-state c))))))
    ((pair? tree)
     (bind-state
      (replace-with-count x (car tree))
      (lambda (a)
        (bind-state
         (replace-with-count x (cdr tree))
         (lambda (d)
           (inj-state (cons a d)))))))
    (else (inj-state tree))))

;traverse
(define traverse
    (lambda (inj _ f)
      (letrec
        ((trav
           (lambda (tree)
             (cond
               [(pair? tree)
                (go-on ([a (trav (car tree))]
                        [d (trav (cdr tree))])
                  (inj (cons a d)))]
               [else (f tree)]))))
        trav)))

;5 Maybe monad
(define (reciprocal x)
  (if (zero? x) (Nothing) (Just (/ 1 x))))

(define traverse-reciprocal
    (traverse Just bind-maybe reciprocal))

;6 Writer monad
(define (halve n)
  (if (even? n) (inj-writer (/ n 2)) (bind-writer (tell n) (lambda (_) (inj-writer n)))))

(define traverse-halve
    (traverse inj-writer bind-writer halve))

;7 State monad
(define (state/sum n)
  (bind-state (get) (lambda (s) (bind-state (put (+ n s)) (lambda (_) (inj-state s))))))

(define traverse-state/sum
    (traverse inj-state bind-state state/sum))  

;Brainteaser - Continuation monad
(define empty-env
  (lambda ()
    (lambda (x) (error "unbound variable ~s" x))))

(define (apply-env env y)
    (env y))
	
(define (extend-env x v env)
    (lambda (y) (if (eqv? y x) v (env y))))

(define (closure id body env)
    (lambda (v) (value-of-cps body (extend-env id v env))))
	  
(define (apply-proc rator rand)
    (rator rand))

(define value-of-cps
  (lambda (expr env)
    (match expr
      [(? number?) (inj-cont expr)]
      [(? boolean?) (inj-cont expr)]       
      [(? symbol?) (inj-cont (apply-env env expr))]
      [`(* ,x1 ,x2) (bind-cont (value-of-cps x1 env)
                               (lambda (x1^)
                                 (bind-cont (value-of-cps x2 env)
                                            (lambda (x2^)
                                              (inj-cont (* x1^ x2^))))))]
      [`(sub1 ,x) (bind-cont (value-of-cps x env)
                             (lambda (x^)
                               (inj-cont (sub1 x^))))]
      [`(zero? ,x) (bind-cont (value-of-cps x env)
                              (lambda (x^)
                                (inj-cont (zero? x^))))]
      [`(if ,test ,conseq ,alt) (bind-cont (value-of-cps test env)
                                           (lambda (test^)
                                             (if test^
                                                 (value-of-cps conseq env)
                                                 (value-of-cps alt env))))]
      [`(capture ,k-id ,body) (callcc (lambda (k)
                                        (value-of-cps body (extend-env k-id k env))))]
      [`(return ,k-exp ,v-exp) (bind-cont (value-of-cps k-exp env)
                                          (lambda (k^)
                                            (bind-cont (value-of-cps v-exp env)
                                                       (lambda (v^)
                                                         (k^ v^)))))]
      [`(lambda (,id) ,body) (inj-cont (closure id body env))]
      [`(,rator ,rand) (bind-cont (value-of-cps rator env)
                                  (lambda (rator^)
                                    (bind-cont (value-of-cps rand env)
                                               (lambda (rand^)
                                                 (apply-proc rator^ rand^)))))])))