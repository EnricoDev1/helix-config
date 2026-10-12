(require "helix/editor.scm")
(require "helix/components.scm")
(require "helix/misc.scm")
(require "helix/static.scm")
(require "helix/commands.scm")

(require-builtin steel/process)

(provide p)

(define eval-string
  "import sys\ntry:\n print(eval('#fmt(#val)'))\nexcept Exception as e:\n print('eval err')")

(define (pyeval expr fmt)
  (~> (command "python3"
               (list "-c"
                     (string-replace (string-replace eval-string "#val" expr) "#fmt" fmt)))
      (set-stdout-piped!)
      (spawn-process) ; returns Ok(process)
      (Ok->value)     ; => process
      (wait->stdout)  ; Ok(eval_res)
      (Ok->value))    ; => eval_res
)

(define (fmt-name fmt)
  (cond
    [(equal? fmt "x") "hex"]
    [(equal? fmt "d") "dec"]
    [(equal? fmt "o") "oct"]
    [(equal? fmt "b") "bin"]
    [else #f]
  )
)


; TODO: trovare il modo di prendere la selezione corrente
(define (p . args)
  (let* ([fmt (fmt-name (car args))]
         [rest (cdr args)])
    (cond
      [(equal? (length args) 0) (set-status! "use: :p <x|d|o|b> [expr]")]
      [(equal? (car args) "x") (set-status! (pyeval (string-join rest) fmt))]
      [(equal? (car args) "d") (set-status! (pyeval (string-join rest) fmt))]
      [(equal? (car args) "o") (set-status! (pyeval (string-join rest) fmt))]
      [(equal? (car args) "b") (set-status! (pyeval (string-join rest) fmt))]
    ) 
  )
)

