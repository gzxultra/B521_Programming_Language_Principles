#lang racket

(require "mk.rkt")
(require "numbers.rkt")

;1
(defrel (listo ls)
  (conde
   ((== '() ls))
   ((fresh (a d)
           (== ls `(,a . ,d))
           (listo d)))))

;2
(defrel (facto n fact)
  (conde
   ((== n (build-num 0))
    (== fact (build-num 1)))
   ((fresh (n-1 factn-1)
           (facto n-1 factn-1)
           (minuso n (build-num 1) n-1)
           (*o factn-1 n fact)))))

;3
(defrel (fibso n fibn fibn+1)
  (conde
   ((== n (build-num 0))
    (== fibn (build-num 1))
    (== fibn+1 (build-num 1)))
   ((fresh (n-1 fibn-1)
           (fibso n-1 fibn-1 fibn)
           (pluso fibn-1 fibn fibn+1)
           (minuso n (build-num 1) n-1)))))

;4
(defrel (reverseo ls q)
  (conde
   ((== '() ls) (== q '()))
   ((=/= '() ls)
    (fresh (a d res)
           (== ls `(,a . ,d))
           (reverseo d res)
           (appendo res `(,a) q)))))

(defrel (lookupo vars vals y o)
  (fresh (var val vars^ vals^)
    (== `(,var . ,vars^) vars)
    (== `(,val . ,vals^) vals)
    (conde
     [(== var y) (== val o)]
     [(=/= var y) (lookupo vars^ vals^ y o)])))

(defrel (folav*o exps vars vals val)
  (conde
   [(== '() exps) (== val '())]
   [(fresh (exp exps^)
      (== `(,exp . ,exps^) exps)
      (fresh (v vs lav)
        (reverseo val lav)
        (== lav `(,v . ,vs))
        (fo-lavo exp vars vals v)
        (folav*o exps^ vars vals vs)))]))

(defrel (fo-lavo exp vars vals val)
  (conde
   [(symbolo exp) (lookupo vars vals exp val)]
   [(== `(,val etouq) exp) 
    (absento 'closure val)
    (absento 'etouq vars)]
   [(fresh (exps pxe)
           (== `(tsil . ,exps) pxe)
           (reverseo exp pxe)
           (absento 'tsil vars)
           (folav*o exps vars vals val))]
   [(fresh (x body)
           (absento 'adbmal vars)
           (=/= 'adbmal x)
           (=/= 'etouq x)
           (symbolo x)	 
           (== `( ,body (,x) adbmal) exp)
           (== `(closure ,x ,body ,vars ,vals) val))]
   [(fresh (rator rand)
           (== exp `(,rand ,rator))
           (fresh (x b vars^ vals^ a c rator-o)
                  (== `(closure ,x ,b ,vars^ ,vals^) rator-o)
                  (fo-lavo rator vars vals rator-o)
                  (fo-lavo rand vars vals a)
                  (fo-lavo b `(,x . ,vars^) `(,a . ,vals^) val)))]))

(defrel (val-ofo exp vars vals val)
  (conde
   [(symbolo exp) (lookupo vars vals exp val)]
   [(== exp `(quote ,val))
    (absento 'closure val)
    #;
    (absento 'quote vars)]
   [(fresh (exps)
      (== exp `(list . ,exps))
      (absento 'list vars)
      (valof*o exps vars vals val))]
   [(fresh (x b)
      #;
      (absento 'λ vars)
      (=/= 'quote x)
      (=/= 'λ x)
      (symbolo x)
      (== `(λ (,x) ,b) exp)
      (== val `(closure ,x ,b ,vars ,vals)))]
   [(fresh (rator rand)
      (== exp `(,rator ,rand))
      (fresh (x b vars^ vals^ a c rator-o)
        (== `(closure ,x ,b ,vars^ ,vals^) rator-o)
        (val-ofo rator vars vals rator-o)
        (val-ofo rand vars vals a)
        (val-ofo b `(,x . ,vars^) `(,a . ,vals^) val)))]))

(defrel (valof*o exps vars vals val)
  (conde
   [(== '() exps) (== val '())]
   [(fresh (exp exps^)
      (== `(,exp . ,exps^) exps)
      (fresh (v vs)
        (== val `(,v . ,vs))
        (val-ofo exp vars vals v)
        (valof*o exps^ vars vals vs)))]))

;5
(defrel (membero x l)
  (conde
   ((fresh (d)
           (== `(,x . ,d) l)))
   ((fresh (a d)
           (== `(,a . ,d) l)
           (membero x d)))))

(defrel (color-middle-eartho colors result)
	(fresh (c1 c2 c3 c4 c5 c6 c7 c8 c9 c10 c11)
		(== result `((lindon . ,c1) (forodwaith . ,c2) (eriador . ,c3) (rhovanion . ,c4)
					   (enedwaith . ,c5) (rohan . ,c6) (gondor . ,c7)
					   (rhun . ,c8) (mordor . ,c9) (khand . ,c10)
					   (harad . ,c11)))
		(=/= c1 c2) (=/= c1 c3) (=/= c2 c3) (=/= c2 c4) (=/= c3 c4) (=/= c3 c5) (=/= c4 c5) (=/= c4 c6) (=/= c5 c6) (=/= c5 c7)
		(=/= c6 c7) (=/= c6 c8) (=/= c7 c8) (=/= c7 c9) (=/= c8 c9) (=/= c8 c10) (=/= c9 c10) (=/= c9 c11) (=/= c10 c11)
		(membero c1 colors) (membero c2 colors) (membero c3 colors) (membero c4 colors) (membero c5 colors)
		(membero c6 colors) (membero c7 colors) (membero c8 colors) (membero c9 colors) (membero c10 colors) (membero c11 colors)))

(define (color-middle-earth colors)
  (run 1 r (color-middle-eartho colors r)))


;...and a failed attempt:

(defrel (adjacento x y adjtable)
  (fresh (a d)
         (== adjtable `(,a . ,d))
         (conde
          ((membero x a)
           (membero y a)
           (=/= x y))
          ((adjacento x y d)))))

(defrel (mapcoloro adjtable coloring colors)
  (conde
   ((== coloring '()))
   ((fresh (a d)
           (== coloring `(,a . ,d))
           (fresh (city1 city2 color1 color2 p)
                  (== a `(,city1 . ,color1))
                  (== p `(,city2 . ,color2))
                  (membero color1 colors)
                  (membero color2 colors)
                  (absento city1 d)
                  (membero p d)
                  (adjacento city1 city2 adjtable)
                  (=/= color1 color2))
           (mapcoloro adjtable d colors)))))

(define middle-earth
    '((lindon eriador forodwaith)
      (forodwaith lindon rhovanion eriador)
      (eriador lindon forodwaith rhovanion enedwaith)
      (rhovanion forodwaith eriador enedwaith rohan rhun)
      (enedwaith eriador rhovanion rohan gondor)
      (rohan enedwaith rhovanion rhun gondor mordor)
      (gondor enedwaith rohan mordor)
      (rhun rohan rhovanion khand mordor)
      (mordor gondor rohan rhun khand harad)
      (khand mordor rhun harad)
      (harad mordor khand)))

;(define result (run 2 r (mapcoloro middle-earth r '(r w b y))))