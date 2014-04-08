;;; whitespace-conf.el
;;
;; Author: Yann KOETH
;; Created: Tue Apr  8 19:05:16 2014 (+0200)
;; Last-Updated: Tue Apr  8 20:36:46 2014 (+0200)
;;           By: Yann KOETH
;;     Update #: 2
;;

(require 'whitespace)

;; Enable by default
(add-hook 'find-file-hook 'whitespace-mode)

;; Make carriage returns blue and tabs yellow
(custom-set-faces
 '(my-carriage-return-face ((((class color)) (:background "blue"))) t)
; '(my-tab-face ((((class color)) (:background "yellow"))) t)
 )

;; Add custom font locks to all buffers and all files
(add-hook
 'font-lock-mode-hook
 (function
  (lambda ()
    (setq
     font-lock-keywords
     (append
      font-lock-keywords
      '(
        ("\r" (0 'my-carriage-return-face t))
;        ("\t" (0 'my-tab-face t))
        ))))))

;; Make characters after column 80 purple
(setq whitespace-style
  (quote (face trailing tab-mark lines-tail)))

(setq whitespace-display-mappings
      '(
        (space-mark 32 [183] [46]) ; 32 SPACE, 183 MIDDLE DOT 「·」, 46 FULL STOP 「.」
        (newline-mark 10 [182 10]) ; 10 LINE FEED
        (tab-mark 9 [9655 9] [92 9]) ; 9 TAB, 9655 WHITE RIGHT-POINTING TRIANGLE 「▷」
        ))
