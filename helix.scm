(require "helix/editor.scm")
(require "helix/misc.scm")
(require (prefix-in hx. "helix/commands.scm"))
(require (prefix-in static. "helix/static.scm"))

(provide open-helix-scm
         open-init-scm)

;;@doc
;; Open the global helix.scm file
(define (open-helix-scm)
  (hx.open (static.get-helix-scm-path)))

;;@Doc
;; Open the global init.scm file
(define (open-init-scm)
  (hx.open (static.get-init-scm-path)))

