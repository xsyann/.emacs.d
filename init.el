;;; .emacs
;;
;; Author: Yann KOETH
;; Created: Tue Apr  8 16:30:50 2014 (+0200)
;; Last-Updated: Fri Apr 11 12:41:56 2014 (+0200)
;;           By: Yann KOETH
;;     Update #: 83
;;

(add-to-list 'load-path "~/.emacs.d")

(setq user-full-name "Yann KOETH")
(setq user-mail-address "contact@xsyann.com")

(load "~/.emacs.d/header2-conf.el")
(load "~/.emacs.d/whitespace-conf.el")

(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories "~/.emacs.d//ac-dict")
(ac-config-default)

;; Global conf

(defalias 'yes-or-no-p 'y-or-n-p) ; Get rid of yes-or-no questions - y or n is enough
(setq require-final-newline 'ask)       ; Ask for final newline
(setq mode-require-final-newline 'ask)  ; Ask for final newline
(display-time)                          ; Time
(setq display-time-24hr-format t)       ; 24h format
(setq inhibit-startup-message t)        ; Inhibit startup message
(column-number-mode 1)                  ; Columns
(line-number-mode 1)                    ; Lines
(delete-selection-mode t)               ; Delete selection mode
(transient-mark-mode t)                 ; Show the region
(setq mark-even-if-inactive t)
(setq visible-bell t)                   ; Disable ring bell
(setq default-tab-width 8)              ; Tab is 8 spaces
(setq-default indent-tabs-mode nil)     ; No tabs
(setq c-default-style "k&r"
      c-basic-offset 8)
(global-font-lock-mode t)               ; Syntax highlight
(setq font-lock-maximum-size nil)       ; Maximum Syntax highlight
(load-library "paren")
(show-paren-mode 1)                     ; Highlight paren
(menu-bar-mode -1)                      ; Hide menu bar
(add-hook 'before-save-hook 'delete-trailing-whitespace) ; Remove trailing spaces

(defun lorem ()
  "Insert a lorem ipsum."
  (interactive)
  (insert "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do "
          "eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad "
          "minim veniam, quis nostrud exercitation ullamco laboris nisi ut "
          "aliquip ex ea commodo consequat. Duis aute irure dolor in "
          "reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla "
          "pariatur. Excepteur sint occaecat cupidatat non proident, sunt in "
          "culpa qui officia deserunt mollit anim id est laborum."))

(defun guard-string (s)
  "Convert Camel case to uppercase underscores."
  (let ((case-fold-search nil))
    (upcase (replace-regexp-in-string "\\([[:upper:]]\\)" "_\\1"
                                      (replace-regexp-in-string "[\. \(\)-]" "_" s) t))))

(defun guard ()
  "Adds the #define __HEADER_H__, etc."
  (interactive)
  (let
      ((flag-name (guard-string (file-name-nondirectory (buffer-name))))
;;       (dir-name (guard-string (file-name-nondirectory (directory-file-name(file-name-directory (buffer-file-name))))))
       )
    (goto-char (point-max))
    (insert (concat "#ifndef         __" flag-name "__\n"))
    (insert (concat "#define         __" flag-name "__\n\n"))
    (setq begin (point-marker))
    (insert (concat "\n\n#endif          /* __" flag-name "__ */\n"))
    (goto-char begin)
    ))
