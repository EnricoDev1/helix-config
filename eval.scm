(require "helix/editor.scm")
(require "helix/components.scm")
(require "helix/misc.scm")
(require "helix/static.scm")
(require "helix/commands.scm")

(require-builtin steel/process)

(provide p)

(define eval-string
  "import sys\ntry:\n print(eval('#fmt(#val)'), end='')\nexcept Exception as e:\n print(end='')")

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
    [(equal? fmt "d") "int"]
    [(equal? fmt "b") "bin"]
    [(equal? fmt "o") "oct"]
    [else #f]
  )
)

(define (p . args)
  (cond
    [(null? args) (set-status! "use: :p <x|d|o|b>")]
    [(not (fmt-name (car args))) (set-status! "invalid format (use x, d, o, b)")]
    [else

      (let* ([fmt (fmt-name (car args))]
            [rest (cdr args)]
            [sel-len (string-length (current-highlighted-text!))]
            [from-args (not (null? rest))]
            [action (if from-args set-status! replace-selection-with)]
            [expr (if from-args (string-join rest) (current-highlighted-text!))]
            [res (trim (pyeval expr fmt))])
        (if (= (string-length res) 0)
          (set-status! "err")
          (action (trim (pyeval expr fmt)))
        )
    )]
  )
)

