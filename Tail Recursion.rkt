#lang racket
(require srfi/1)

(define L
(build-list 1000 values))
(set! L (cdr L))
(define S
  (build-list 0 values))
(define c 0)

(define (numbers M);Main, test using this

  (if (= (howMany S) M)
      (printf "")
      (begin
        ;(printf "test ")
        (primes)
        ;(set! c(+ c 1))
        (numbers M)
        
       )
   )
  S
)

(define (howMany list)
  (if (null? list)
      0
      (+ 1 (howMany (cdr list)))))

  (define (primes)
    (if (prime (car L))
        (begin
          (set! S (append S (list(car L))))
          ( set! L(cdr L))
          ;(primes)
          )
        (begin
          ( set! L(cdr L))
          ;(primes)
          ))
    )

(define (prime L)
  (define (prime-helper L k)
    (cond ((= L k) #t)
          ((= (remainder L k) 0) #f)
          (else
           (prime-helper L (+ k 1)))))
  (cond ((= L 1) #f)
        ((= L 2) #t)
         (else
          (prime-helper L 2))))