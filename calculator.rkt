#lang racket

; Calculator implementation in Scheme

; Define a global environment to store variables
(define global-env '())

; Helper function to look up variable value
(define (lookup-variable var env)
  (let ((binding (assoc var env)))
    (if binding
        (cdr binding)
        (error "Undefined variable" var))))

; Helper function to update or add variable to environment
(define (update-env var value env)
  (let ((existing-binding (assoc var env)))
    (if existing-binding
        (map (lambda (binding)
               (if (eq? (car binding) var)
                   (cons var value)
                   binding))
             env)
        (cons (cons var value) env))))

; Arithmetic operations
(define (calculator-eval expr)
  (cond 
    ; Number literal
    ((number? expr) expr)
    
    ; Variable lookup
    ((symbol? expr) 
     (lookup-variable expr global-env))
    
    ; Assignment
    ((and (list? expr) (eq? (car expr) '=))
     (let ((var (cadr expr))
           (value (calculator-eval (caddr expr))))
       (set! global-env (update-env var value global-env))
       value))
    
    ; Basic arithmetic operations
    ((list? expr)
     (let ((op (car expr))
           (args (map calculator-eval (cdr expr))))
       (case op
         ((+) (apply + args))
         ((-) (apply - args))
         ((*) (apply * args))
         ((/) (if (or (null? args) 
                      (and (= (length args) 2) 
                           (= (cadr args) 0)))
                  (error "Division by zero")
                  (apply / args)))
         (else (error "Unknown operation" op)))))
    
    (else (error "Invalid expression" expr))))

; Test cases
(define (run-tests)
  (display "Running Calculator Tests:\n")
  
  ; Basic arithmetic tests
  (display "Addition Test: ")
  (display (calculator-eval '(+ 5 3)))
  (newline)
  
  (display "Subtraction Test: ")
  (display (calculator-eval '(- 10 4)))
  (newline)
  
  (display "Multiplication Test: ")
  (display (calculator-eval '(* 6 7)))
  (newline)
  
  ; Variable assignment and usage tests
  (display "Variable Assignment Test: ")
  (calculator-eval '(= x 10))
  (display (calculator-eval 'x))
  (newline)
  
  (display "Complex Expression Test: ")
  (display (calculator-eval '(+ x 5)))
  (newline)
  
  ; Division tests
  (display "Division Test: ")
  (display (calculator-eval '(/ 15 3)))
  (newline)
  
  ; Error handling tests
  (display "Division by Zero Test: ")
  (with-handlers 
      ([exn:fail? 
        (lambda (exn) 
          (display "Caught division by zero error")
          (newline))])
    (calculator-eval '(/ 10 0)))
  
  ; Nested expression test
  (display "Nested Expression Test: ")
  (display (calculator-eval '(+ (* 2 3) (- 10 4))))
  (newline))

; Run the tests
(run-tests)
