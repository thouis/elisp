;;; from http://richardriley.net/projects/emacs/dotprogramming#sec-1.5
(when (load "flymake" t)
  (defun flymake-pycheckers-init ()
    (let* ((temp-file (flymake-init-create-temp-buffer-copy
                       'flymake-create-temp-inplace))
           (local-file (file-relative-name
                        temp-file
                        (file-name-directory buffer-file-name))))
      (list "/Users/thouis/elisp/pycheckers.sh"  (list local-file)))))

(add-to-list 'flymake-allowed-file-name-masks
               '("\\.py\\'" flymake-pycheckers-init))

(add-hook 'python-mode-hook 
          (lambda () 
            (unless (eq buffer-file-name nil) (flymake-mode 1)) ;dont invoke flymake on temporary buffers for the interpreter
            (local-set-key [f2] 'flymake-goto-prev-error)
            (local-set-key [f3] 'flymake-goto-next-error)
            ))

;; -*- emacs-lisp -*-
;; License: Gnu Public License
;;
;; Additional functionality that makes flymake error messages appear
;; in the minibuffer when point is on a line containing a flymake
;; error. This saves having to mouse over the error, which is a
;; keyboard user's annoyance

;;flymake-ler(file line type text &optional full-file)
(defvar flypy-hidden-overlays nil)
(defun show-fly-err-at-point ()
  "If the cursor is sitting on a flymake error, display the
message in the minibuffer"
  (interactive)
    ; hide the current overlay, if there is one
  (dolist (overlay (find-overlays-specifying 'flymake-overlay))
    (setq flypy-hidden-overlays (cons (list overlay (overlay-start overlay) (overlay-end overlay) (overlay-buffer overlay))
                                      flypy-hidden-overlays))
    (delete-overlay overlay))
                                        ; put back any that shouldn't be hidden
  (let ((still-hidden nil))
    (dolist (overlay_w_buf flypy-hidden-overlays)
      (if (or (< (point) (nth 1 overlay_w_buf))
              (> (point) (nth 2 overlay_w_buf))
              (not (eq (nth 3 overlay_w_buf) (current-buffer))))
          (progn
            (apply 'move-overlay overlay_w_buf))
        (setq still-hidden (cons overlay_w_buf still-hidden))))
    (setq flypy-hidden-overlays still-hidden))
  (let ((line-no (line-number-at-pos)))
    (dolist (elem flymake-err-info)
      (if (eq (car elem) line-no)
          (let ((err (car (second elem))))
            (message "%s" (fly-pyflake-determine-message err)))))))

(defun fly-pyflake-determine-message (err)
  "pyflake is flakey if it has compile problems, this adjusts the
message to display, so there is one ;)"
  (cond ((not (or (eq major-mode 'Python) (eq major-mode 'python-mode) t)))
        ((null (flymake-ler-file err))
         ;; normal message do your thing
         (flymake-ler-text err))
        (t ;; could not compile err
         (format "compile error, problem on line %s" (flymake-ler-line err)))))

(defadvice flymake-goto-next-error (after display-message activate compile)
  "Display the error in the mini-buffer rather than having to mouse over it"
  (show-fly-err-at-point))

(defadvice flymake-goto-prev-error (after display-message activate compile)
  "Display the error in the mini-buffer rather than having to mouse over it"
  (show-fly-err-at-point))

(defadvice flymake-mode (before post-command-stuff activate compile)
  "Add functionality to the post command hook so that if the
cursor is sitting on a flymake error the error information is
displayed in the minibuffer (rather than having to mouse over
it)"
  (set (make-local-variable 'post-command-hook)
       (cons 'show-fly-err-at-point post-command-hook)))

(defun find-overlays-specifying (prop)
            (let ((overlays (overlays-at (point)))
                  found)
              (while overlays
                (let ((overlay (car overlays)))
                  (if (overlay-get overlay prop)
                      (setq found (cons overlay found))))
                (setq overlays (cdr overlays)))
              found))
