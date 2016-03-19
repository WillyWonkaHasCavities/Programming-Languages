#lang racket
(define call/cc call-with-current-continuation)

(define s11 '())  ;; row 1 columns 1-4
(define s12 '())
(define s13 '())
(define s14 '())

(define s21 '())  ;; row 2 columns 1-4
(define s22 '())
(define s23 '())
(define s24 '())

(define s31 '())  ;; row 3 columns 1-4
(define s32 '())
(define s33 '())
(define s34 '())

(define s41 '())  ;; row 4 columns 1-4
(define s42 '())
(define s43 '())
(define s44 '())

;; implementation of amb
(define amb-fail (lambda () (error 'no-solution)))

(define-syntax amb
  (syntax-rules ()
    ((amb alt ...)
     (let ((prev-amb-fail amb-fail))
       (call/cc 
         (lambda (sk)
           (call/cc 
             (lambda (fk)
               (set! amb-fail (lambda ()
                                (set! amb-fail prev-amb-fail)
                                (fk 'fail)))
               (sk alt)))
            ...
           (prev-amb-fail)))))))

;; forces pred to be true
(define assert (lambda (pred) (if (not pred) (amb) '())))

;; check whether an element of one given list is a member of any 
;; of the other given lists
(define distinct?
  (lambda (o l)
    (if (null? l)
    #t
    (if (= (car l) o)
            #f
            (distinct? o (cdr l))))))

(define magic-squares
  (lambda ()
    (set! s11 (amb 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16))
     (set! s12 (amb 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16))
    (assert (distinct? s12 (list s11)))
    (set! s13 (amb 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16))
    (assert (distinct? s13 (list s12 s11)))
    (assert (< (+ s11 s12 s13) 34))
    (set! s14 (- 34 (+ s11 s12 s13)))
    (assert (distinct? s14 (list s13 s12 s11)))
    (set! s21 (amb 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16))
    (assert (distinct? s21 (list s14 s13 s12 s11)))
    (set! s31 (amb 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16))
    (assert (distinct? s31 (list s21 s14 s13 s12 s11)))
    (assert (< (+ s11 s21 s31) 34))
    (set! s41 (- 34 (+ s11 s21 s31)))
    (assert (distinct? s41 (list s31 s21 s14 s13 s12 s11)))
    (set! s22 (amb 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16))
    (assert (distinct? s22 (list s41 s31 s21 s14 s13 s12 s11)))
    (set! s32 (amb 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16))
    (assert (distinct? s32 (list s22 s41 s31 s21 s14 s13 s12 s11)))
    (assert (< (+ s12 s22 s32) 34))
    (set! s42 (- 34 (+ s12 s22 s32)))
    (assert (distinct? s42 (list s32 s22 s41 s31 s21 s14 s13 s12 s11)))
    (assert (< (+ s41 s32 s14) 34))
    (set! s23 (- 34 (+ s41 s32 s14)))
    (assert (distinct? s23 (list s42 s32 s22 s41 s31 s21 s14 s13 s12 s11)))
    (assert (< (+ s23 s32 s22) 34))
    (set! s33 (- 34 (+ s23 s32 s22)))
    (assert (distinct? s33 (list s23 s42 s32 s22 s41 s31 s21 s14 s13 s12 s11)))
    (assert (< (+ s11 s14 s41) 34))
    (set! s44 (- 34 (+ s11 s14 s41)))
    (assert (distinct? s44 (list s33 s23 s42 s32 s22 s41 s31 s21 s14 s13 s12 s11)))
    (assert (= (+ s11 s22 s33 s44) 34))
    (assert (< (+ s21 s22 s23) 34))
    (set! s24 (- 34 (+ s21 s22 s23)))
    (assert (distinct? s24 (list s44 s33 s23 s42 s32 s22 s41 s31 s21 s14 s13 s12 s11)))
    (assert (< (+ s31 s32 s33) 34))
    (set! s34 (- 34 (+ s31 s32 s33)))
    (assert (distinct? s34 (list s24 s44 s33 s23 s42 s32 s22 s41 s31 s21 s14 s13 s12 s11)))
    (assert (= (+ s14 s24 s34 s44) 34))
    (assert (< (+ s41 s42 s44) 34))
    (set! s43 (- 34 (+ s41 s42 s44)))
    (assert (distinct? s43 (list s34 s24 s44 s33 s23 s42 s32 s22 s41 s31 s21 s14 s13 s12 s11)))
    (assert (= (+ s13 s23 s33 s43) 34))
    (print s11 s12 s13 s14 s21 s22 s23 s24 s31 s32 s33 s34 s41 s42 s43 s44)))

(define print
  (lambda (s11 s12 s13 s14 s21 s22 s23 s24 s31 s32 s33 s34 s41 s42 s43 s44)
    (display s11)(display " ")
    (display s12)(display " ")
    (display s13)(display " ")
    (display s14)(display " ")(display "Row 1")(newline)
    (display s21)(display " ")
    (display s22)(display " ")
    (display s23)(display " ")
    (display s24)(display " ")(display "Row 2")(newline)
    (display s31)(display " ")
    (display s32)(display " ")
    (display s33)(display " ")
    (display s34)(display " ")(display "Row 3")(newline)
    (display s41)(display " ")
    (display s42)(display " ")
    (display s43)(display " ")
    (display s44)(display " ")(display "Row 4")(newline))) 