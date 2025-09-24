(load-library "cl")

; breaks mac
;;(if (> (string-to-number emacs-version) 18) (progn (menu-bar-mode -1)))

(if (and (>= (string-to-number emacs-version) 21) (fboundp 'tool-bar-mode)) (tool-bar-mode -1))


(put 'minibuffer-complete-and-exit 'disabled nil)
(put 'eval-expression 'disabled nil)
(setq visible-bell t)
(put 'narrow-to-region 'disabled nil)
(put 'narrow-to-page 'disabled nil)
(setq inhibit-startup-message t)
(setq fill-column 79)
(setq auto-save-interval 20)
(setq mode-line-format (list 'buffer-file-name "%f %* %[(%m)%] L:%l" "%b %* %[(%m)%] L:%l"))
(setq svn-status-state-mark-modeline 'nil) ; thank you, no
(setq case-fold-search nil)
(if (boundp 'suggest-key-bindings) 
    (setq suggest-key-bindings nil))

;; setup variables for both C ainstnd C++ modes
(defun set-c-vars () 
  (when (featurep 'hil)
    (local-set-key "\M-;" 'hil-highlight))
  (setq require-final-newline t)
  (local-set-key "\ec" 'timecomment)
  (local-set-key "\e{" 'insert-c-braces)
  (local-set-key "\em" 'make-function)
  (local-set-key "\e'" 'c-find-tag-exact)
  (local-set-key "\t" 'smart-tab)
  (set-variable 'c-basic-offset 4)
  (set-variable 'font-lock-maximum-decorate 2))

;; Start C mode
(defun start-c-mode ()
  (set-c-vars)
  (if (and (bobp) (eobp))   ; new file?
      (new-c-file-header)))

;; Make a header for a new c file
(defun new-c-file-header ()
  (insert "/* " (buffer-name) " - */")
  (newline) (newline)
  (set-buffer-modified-p nil))

;; Start C++ mode
(defun start-c++-mode ()
  (set-c-vars)
  (if (and (bobp) (eobp))   ; new file?
      (new-c++-file-header)))

;; Make a header for a new c++ file
(defun new-c++-file-header ()
  (insert "// " (buffer-name) " - ")
  (newline) (newline)
  (not-modified))

;; this is bound to ESC-{ in c-mode buffers.
(defun insert-c-braces ()
  "insert a matched pair of C curly braces in buffer at point."
  (interactive)
  (end-of-line)
  (insert "{\n\n}")
  (forward-line -2)
  (indent-according-to-mode)
  (forward-line 1)
  (indent-according-to-mode)
  (forward-line 1)
  (indent-according-to-mode)
  (forward-line -1)
  (end-of-line))

;; Mode hooks
(setq auto-mode-alist
      (append 
       '(("\\.h$" . c++-mode)
	 ("\\.lex$" . c++-mode)
	 ("emacs" . emacs-lisp-mode)
         ("\\.el$" . emacs-lisp-mode)
         ("\\.py.*$" . python-mode)
         ("\\.m$" . octave-mode)
         ("Snakefile*" . snakemake-mode)
         ("\\.R$" . R-mode)
         ("\\.r$" . R-mode))
       auto-mode-alist))

(setq major-mode 'text-mode)
(add-hook 'text-mode-hook 'turn-on-auto-fill)

(add-hook 'c-mode-hook 'start-c-mode)
(add-hook 'c++-mode-hook 'start-c++-mode)

(add-hook 'scheme-mode-hook 'start-scheme-or-elisp-mode)
(defun start-scheme-or-elisp-mode ()
  (when (featurep 'hil)
    (local-set-key "\M-;" 'hil-highlight)))

;; Key Bindings
(global-set-key "\C-R" 'isearch-backward-regexp)
(global-set-key "\C-S" 'isearch-forward-regexp)
(global-set-key "\C-H" 'backward-delete-char-untabify)

(global-set-key "\C-X\C-E" 'compile)
(global-set-key "\C-X\C-K" 'kill-compilation)
(global-set-key "\C-X\C-N" 'next-error)
(global-set-key "\C-X\C-B" 'switch-to-buffer)

(global-set-key "\C-X\C-V" 'find-file)
(global-set-key "\C-X\C-F" 'find-file-other-window)
(global-set-key "\C-Xv" 'find-file)

(global-unset-key "\C-xn")
(global-set-key "\C-xn" 'new-frame)
(global-set-key "\C-x-" 'delete-frame)

(global-set-key "\C-z" 'set-mark-command)
(global-set-key "\e?" 'help-for-help)
(global-set-key "\eg" 'goto-line)
(global-set-key "\er" 'replace-regexp)
(global-set-key "\C-w" 'kill-region)

(setq mac-command-modifier 'meta)
(setq mac-option-modifier 'meta)
(global-set-key "\M-\C-?" 'backward-kill-word)
(global-set-key "\M-c" 'copy-region-as-kill)

(global-set-key "\M-OA" 'previous-line)     ; up-arrow
(global-set-key "\M-OB" 'next-line)         ; down-arrow
(global-set-key "\M-OC" 'forward-char)      ; right-arrow
(global-set-key "\M-OD" 'backward-char)     ; left-arrow

(global-unset-key "\M-[")
(global-set-key "\M-[A" 'previous-line)     ; up-arrow - SUN
(global-set-key "\M-[B" 'next-line)         ; down-arrow - SUN
(global-set-key "\M-[C" 'forward-char)      ; right-arrow - SUN
(global-set-key "\M-[D" 'backward-char)     ; left-arrow - SUN

(global-set-key "\M-`" 'next-multiframe-window)

;;search backwards, blink the match, then move back to where we were.
(defun my-show-match ()
  (interactive)
  (let ((oldpos (point)))
    (skip-chars-backward "^)")
    (if (looking-at ")")
	(progn
	    (goto-char (1+ (point)))
	      (blink-matching-open))
      (blink-matching-open))
    (goto-char oldpos)))

(defun c-find-tag-exact () 
  (interactive)
  (find-tag (concat "\C-j" (funcall find-tag-default-function) "(")))

(defun my-indent-buffer ()
  (interactive)
  (save-excursion
    (goto-char 1)
    (while (< (point) (buffer-size))
      (funcall indent-line-function)
      (forward-line 1))))

(defun yank-quoted ()
  (interactive)
  (yank)
  (exchange-point-and-mark)
  (while (< (point) (mark))
    (beginning-of-line)
    (insert "> ")
    (forward-line 1)))

(global-unset-key "\C-x\C-i")
(global-set-key "\C-x\C-i" 'insert-file)

(global-set-key "\C-x\C-x" 'exchange-point-and-mark)

(setq-default indent-tabs-mode nil)

(defun cur-line-len ()
  (interactive)
  (save-excursion
    (- 
     (progn
       (end-of-line)
       (point))
     (progn
       (beginning-of-line)
       (point)))))

(defun justify-continues ()
  (interactive)
  (save-excursion
    (goto-char (point-min))
    (while (re-search-forward "\\(.*\\\\\n\\)+" (point-max) t)
      (let ((beg (match-beginning 0))
	    (end (match-end 0))
	    (len 0))
	(goto-char beg)
	(while (< (point) end)
	  (let ((cur-len (cur-line-len)))
	    (if (> cur-len len)
		(setq len cur-len)))
	  (forward-line))
	(goto-char beg)
	(while (< (point) end)
	  (end-of-line)
	  (backward-char)
	  (let ((num-to-add (- len (cur-line-len))))
	    (insert (make-string num-to-add ?\ ))
	    (setq end (+ end num-to-add)))
	  (forward-line))
	(goto-char end)))))


(define-key minibuffer-local-must-match-map "\040" 'minibuffer-complete)
(define-key minibuffer-local-must-match-map "\011" 'minibuffer-complete)
(define-key minibuffer-local-completion-map "\040" 'minibuffer-complete)
(define-key minibuffer-local-completion-map "\011" 'minibuffer-complete)
(define-key minibuffer-local-filename-completion-map " " 'minibuffer-complete)

;; this is from examples in advice.el
;; advice is 4leet, i must read more about it.
(defadvice switch-to-buffer-other-window (before existing-buffers-only activate)
  "When called interactively switch to existing buffers only, unless 
when called with a prefix argument."
  (interactive 
   (list (read-buffer "Switch to buffer in other window: " (other-buffer) 
                      (null current-prefix-arg)))))


(defvar *win-stack* ())
(defun push-win ()
  (interactive)
  (setq *win-stack* (cons (current-window-configuration) *win-stack*)))

(defun pop-win ()
  (interactive)
  (and (car *win-stack*)
       (progn
          (set-window-configuration (car *win-stack*))
           (setq *win-stack* (cdr *win-stack*)))))

(defun last-win ()
  (interactive)
  (and (car *win-stack*)
       (set-window-configuration (car *win-stack*))))

(defadvice switch-to-buffer (before existing-hidden-buffers-only activate)
  "When called interactively switch to existing, hidden buffers only,
unless called with a prefix argument."
  (interactive
   (list 
    (if current-prefix-arg
	(read-buffer "Switch to buffer: " (other-buffer) nil)
      (let ((prompt (format "Switch to buffer (default %s) "
			    (buffer-name (other-buffer))))
	    ;; completing-read requires an assoc list instead of a
	    ;; straight list.  oh well, it can be used to our
	    ;; advantage below (to handle the "" case, which is
	    ;; returned by c-r when there is no input).  list-grep the
	    ;; buffers so that only non-visible buffers are in the
	    ;; completion list and construct an alist of (buffer-name
	    ;; . buffer).  skip buffers that start with spaces as
	    ;; well.
	    (buflist 
	     (cons (cons "" (other-buffer))
		   (mapcar (lambda (b) (cons (buffer-name b) b))
			   (list-grep 
			    (buffer-list) 
			    (lambda (b) 
			      (not 
			       (or (get-buffer-window b t)
				   (= ?\040 (string-to-char (buffer-name b)))))))))))
	(cdr (assoc (completing-read prompt (cdr buflist) nil t) buflist)))))))


(defun list-grep (l pred)
  (if (consp l)
      (if (funcall pred (car l))
	    (cons (car l) (list-grep (cdr l) pred))
	(list-grep (cdr l) pred))
    nil))

(if (boundp 'frame-title-format) (setq frame-title-format "%b"))

(setq auto-save-main-directory nil)

(setq enable-recursive-minibuffers t)
; (resize-minibuffer-mode)

(add-hook 'emacs-lisp-mode-hook 'start-scheme-or-elisp-mode)

(setq comint-output-filter-functions 
      '(comint-strip-ctrl-m 
        comint-postoutput-scroll-to-bottom 
        comint-watch-for-password-prompt))

(global-set-key "\C-x44" 'toggle-accents)

(defun timestring () 
  (interactive)
  (insert (current-time-string)))

(defun timecomment ()
  (interactive)
  (insert "// rjones: (")
  (timestring)
  (insert ") - ")
  (indent-according-to-mode))

(setq cursor-in-non-selected-windows nil)

;(pc-selection-mode nil)
;(transient-mark-mode nil)

(setq mark-even-if-inactive t)

(global-set-key (kbd "M-DEL") 'backward-kill-word)

(add-hook 'python-mode-hook 'my-python-hook)
; this gets called by outline to deteremine the level. Just use the length of the whitespace
(defun py-outline-level ()
  (let (buffer-invisibility-spec)
    (save-excursion
      (skip-chars-forward "\t ")
      (current-column))))
; this get called after python mode is enabled
(defun my-python-hook ()
  (local-set-key [\C-tab] 'python-indent-shift-right)
  (local-set-key [\C-\S-tab] 'python-indent-shift-left)
  (local-set-key [\M-/] 'dabbrev-expand)
  ; make paren matches visible
  (show-paren-mode 1)
  ; force into unix linefields
  ; (set-buffer-file-eol-type <'unix)
  (setq show-trailing-whitespace t)
  (setq fill-column 79)
)


(defun set-buffer-file-eol-type (eol-type)
   "Set the file end-of-line conversion type of the current buffer to
 EOL-TYPE.
 This means that when you save the buffer, line endings will be converted
 according to EOL-TYPE.

 EOL-TYPE is one of three symbols:

   unix (LF)
   dos (CRLF)
   mac (CR)

 This function marks the buffer modified so that the succeeding
 \\[save-buffer]
 surely saves the buffer with EOL-TYPE.  From a program, if you don't want
 to mark the buffer modified, use coding-system-change-eol-conversion
 directly [weikart]."
   (interactive "SEOL type for visited file (unix, dos, or mac): ")
   (if (not (eq (coding-system-change-eol-conversion
                 buffer-file-coding-system eol-type)
                buffer-file-coding-system))
       (progn
         (setq buffer-file-coding-system (coding-system-change-eol-conversion
                                          buffer-file-coding-system eol-type))
         (set-buffer-modified-p t)
         (force-mode-line-update))))

(set-face-background 'trailing-whitespace "#100")

;; flyspell
(setq-default ispell-program-name "/usr/local/bin/aspell")

(setq resize-mini-windows t
      max-mini-window-height .85)

(setenv "VIRTUAL_ENV" "/Users/thouis/VENV36")
(setenv "PYTHONHOME")

(require 'python)

(require 'column-marker)

(autoload 'snakemake-mode "snakemake" "Snakemake mode" t nil)

(defun smart-tab ()
      "This smart tab is minibuffer compliant: it acts as usual in
    the minibuffer. Else, if mark is active, indents region. Else if
    point is at the end of a symbol, expands it. Else indents the
    current line."
      (interactive)
      (if (minibufferp)
          (unless (minibuffer-complete)
            (dabbrev-expand nil))
        (if mark-active
            (indent-region (region-beginning)
                           (region-end))
          (if (looking-at "\\_>")
              (dabbrev-expand nil)
            (indent-for-tab-command)))))


(defadvice bibtex-find-text (around advice-remove-tab-annoyance activate)
  (interactive)
  (if (string-match-p "^\\s-*$" (buffer-substring-no-properties (point-at-bol) (point)))
      (indent-for-tab-command)
    ad-do-it))

;; Configure flycheck for Python
(add-hook 'python-mode-hook '(lambda () (flycheck-mode)))
(set-variable 'flycheck-display-errors-display 0.1)
(define-key python-mode-map (kbd "TAB") 'smart-tab)
(define-key python-mode-map (kbd "C-c C-n") 'flycheck-next-error)
(define-key python-mode-map (kbd "C-c C-p") 'flycheck-previous-error)
(set-variable 'flycheck-python-flake8-executable "/Users/thouis/VENV39/bin/flake8")
(setq flycheck-flake8-maximum-line-length 120)


(setq yow-file "~/elisp/yow_file_zippy_pinhead_quotes.txt.gz")

(require 'tramp)
;; (add-to-list 'tramp-remote-path 'tramp-own-remote-path)
;; TRAMP gcloud ssh
(add-to-list 'tramp-methods
  '("gssh"
    (tramp-login-program        "/usr/local/bin/gssh")
    (tramp-login-args           (("%u") ("%h")))
    (tramp-async-args           (("-q")))
    (tramp-remote-shell         "/bin/sh")
    (tramp-remote-shell-args    ("-c"))
    (tramp-gw-args              (("-o" "GlobalKnownHostsFile=/dev/null")
                                 ("-o" "UserKnownHostsFile=/dev/null")
                                 ("-o" "StrictHostKeyChecking=no")))
    (tramp-default-port         22)))
;; speed up tramp
(setq tramp-completion-reread-directory-timeout 600)

;; recent files
;; must be below the tramp setup for gssh
(require 'recentf)
(recentf-mode 1)
(setq recentf-max-menu-items 50)
(setq recentf-max-saved-items 50)
(global-set-key "\C-x\ \C-r" 'recentf-open-files)
(run-at-time nil (* 5 60) 'recentf-save-list)

(defun unwrap-line ()
      "Remove all newlines until we get to two consecutive ones.
    Or until we reach the end of the buffer.
    Great for unwrapping quotes before sending them on IRC."
      (interactive)
      (let ((start (point))
            (end (copy-marker (or (search-forward "\n\n" nil t)
                                  (point-max))))
            (fill-column (point-max)))
        (fill-region start end)
        (goto-char end)
        (newline)
        (goto-char start)))


;;; multi-mode for editing html/js
(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.phtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.tpl\\.php\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.[agj]sp\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.as[cp]x\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.erb\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.mustache\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.djhtml\\'" . web-mode))
(add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))

;; Indentation for web-mode.el
(setq web-mode-markup-indent-offset 2)
(setq web-mode-css-indent-offset 2)
(setq web-mode-code-indent-offset 2)
