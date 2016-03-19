#lang racket


(define s '(1 2 3 4 5));test cases
(define d '(a b c d e));test
(define f '(! @ * $ %));test

(define multiply
      (lambda (l)
         (if (null? l)
             (printf" error")
             (begin 
               (pl l) ; performs the printign actions through pl
                   
               ))))

;(define escape
 ;     (lambda ()
  ;       (set! halt (call/cc (lambda (k) k)))
   ;      0))



(define pl
      (lambda (l)
         (if (null? l)
             '()
             (begin (display (car l)) (printf" ")))))


(define main
  (lambda (a b c)
   (if (null? a) ; Allows for any size list
      '()
      (begin
        (if(null? a)
           '()
           (multiply a))
        (if(null? b)
           (set! b '(0))
           (multiply b))
        (if(null? c)
           (set! c '(0))
           (multiply c))
        
        (main (cdr a) (cdr b) (cdr c)) ;recursive process
       )
       )
    ))