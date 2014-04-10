;;; header2-conf.el
;;
;; Author: Yann KOETH
;; Created: Tue Apr  8 16:29:02 2014 (+0200)
;; Last-Updated: Thu Apr 10 18:31:18 2014 xsyann
;;           By: Yann KOETH
;;     Update #: 29
;;

(require 'header2)

;; Header items

(setq make-header-hook '(header-title
                         header-blank
                         header-author
                         header-creation-date
                         header-modification-date
                         header-modification-author
                         header-update-count
                         header-end
                         ))

;; Add a new header in blank files

(autoload 'auto-make-header "header2")

;(add-hook 'sh-mode-hook        'auto-make-header)
;(add-hook 'makefile-mode-hook  'auto-make-header)
;(add-hook 'c-mode-common-hook  'auto-make-header)
(add-hook 'emacs-lisp-mode-hook 'auto-make-header)
(add-hook 'python-mode-hook     'auto-make-header)
(add-hook 'php-mode-hook        'auto-make-header)
(add-hook 'lisp-mode-hook       'auto-make-header)
(add-hook 'java-mode-hook       'auto-make-header)

(add-hook 'sh-mode-hook         'auto-make-epitech-header)
(add-hook 'makefile-mode-hook   'auto-make-epitech-header)
(add-hook 'c-mode-common-hook   'auto-make-epitech-header)


;; Update header at writing

(autoload 'auto-update-file-header "header2")
(add-hook 'write-file-hooks 'auto-update-file-header)


;; Maximum number of chars to examine for header updating
(setq header-max 600)

;; Trim function
(defun s-trim-right (s)
  "Remove whitespace at the end of S."
  (if (string-match "[ \t\n\r]+\\'" s)
      (replace-match "" t t s)
    s))

(defun s-trim-left (s)
  "Remove whitespace at the beginning of S."
  (if (string-match "\\`[ \t\n\r]+" s)
      (replace-match "" t t s)
    s))

;; Blank line without trailing space
(defsubst header-blank ()
  (insert (s-trim-right header-prefix-string)  "\n"))

;; Header end
(defun header-end ()
  (insert (cond ((nonempty-comment-end))
                ((and comment-start (= 1 (length comment-start)))
                 (make-string 2 (aref comment-start 0)))
                ((s-trim-right (nonempty-comment-start)))
                (t (make-string 2 ?\;)))
          "\n\n")
  (setq return-to  (1+ (point))))

;; Set cursor at the end
(defun header-end-line ()
  "Insert a divider line."
  (insert (cond ((nonempty-comment-end))
                ((and comment-start (= 1 (length comment-start)))
                 (make-string 70 (aref comment-start 0)))
                ((nonempty-comment-start))
                (t (make-string 70 ?\;)))
          "\n")
  (setq return-to  (1+ (point)))
)

;; Override header-title to remove the room for a description
(defsubst header-title ()
  "Insert buffer's file name and DON'T leave room for a description.
In `emacs-lisp-mode', this should produce the title line for library
packages."
  (insert (concat comment-start (and (= 1 (length comment-start)) header-prefix-string)
                  (if (buffer-file-name)
                      (file-name-nondirectory (buffer-file-name))
                    (buffer-name))
                  "\n"))
  (setq return-to  (1- (point))))


;; EPITECH header

(defun auto-make-epitech-header ()
  "Epitech header compatibility"

  (setq make-header-hook '(header-begin
                           header-filename
                           header-blank
                           header-author
                           header-contact
                           header-blank
                           header-creation-date
                           header-modification-date
                           header-end
                           ))

  (defun header-filename ()
    (insert header-prefix-string
            (if (buffer-file-name)
                (file-name-nondirectory (buffer-file-name))
              (buffer-name))
            "\n"))

  (defun header-author ()
    (insert header-prefix-string "Made by " (user-login-name) "\n"))

  (defsubst header-begin ()
    (insert (concat
             (s-trim-right comment-start)
             (and (= 1 (length comment-start))
                  (s-trim-right header-prefix-string))
             "\n")))

  (defun header-end ()
    (insert (cond ((s-trim-left (nonempty-comment-end)))
                  ((and comment-start (= 1 (length comment-start)))
                   (make-string 2 (aref comment-start 0)))
                  ((s-trim-right (nonempty-comment-start)))
                  (t (make-string 2 ?\;)))
            "\n\n")
    (setq return-to  (1+ (point))))

  (defsubst header-modification-date ()
    (insert header-prefix-string "Last update ")
    (insert (header-date-string) "\n"))

  (defsubst header-creation-date ()
    (insert header-prefix-string "Started on  ")
    (insert (header-date-string) "\n"))

  (defsubst header-contact ()
    (insert header-prefix-string "Contact <")
    (insert user-mail-address ">\n"))

  (register-file-header-action "Last update[ \t]*" 'update-last-modified-date)

  ;; Add the login at the end of date
  (defun header-date-string ()
    "Current date and time."
    (concat (format-time-string
             (cond ((stringp header-date-format) header-date-format)
                   (header-date-format "%a %b %e %T %Y")
                   (t                  "%Y-%m-%dT%T%z")) ; An alternative: "%a %b %e %T %Y (UTC)"
             (current-time)
             (not header-date-format))
            " " (user-login-name)
            ))

  ;; Set double header prefix for C mode
  (defun header-prefix-string ()
    (cond
    ;; E.g. Lisp.
    ((and comment-start (= 1 (length comment-start)))
     (concat comment-start comment-start " "))

    ;; E.g. C++ and ADA.
    ;; Special case, three letter comment-start where the first and
    ;; second letters are the same.
    ((and comment-start (= 3 (length comment-start))
          (equal (aref comment-start 1) (aref comment-start 0)))
     comment-start)

    ;; E.g. C.
    ;; Other three-letter comment-start -> grab the middle character
    ((and comment-start (= 3 (length comment-start)))
     (concat (make-string 2 (aref comment-start 1)) " "))

    ((and comment-start  (not (nonempty-comment-end)))

     ;; Note: no comment end implies that the full comment-start must be
     ;; used on each line.
     comment-start)
    (t ";; ")))       ; Use Lisp as default.

  (auto-make-header)
)
