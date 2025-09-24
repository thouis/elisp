
;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(require 'package)
(package-initialize)
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/") t)
(add-to-list 'package-archives
             '("melpa-stable" . "https://stable.melpa.org/packages/") t)

(setq debug-on-error t)
(setq max-specpdl-size 2000)
(setq max-lisp-eval-depth 1000)

(add-to-list 'load-path (expand-file-name "~/elisp"))

(load-library "mysimple")
(load-library "x")


;(setq debug-on-error nil)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(completions-format 'vertical)
 '(global-font-lock-mode t nil (font-lock))
 '(jupyter-executable "/Users/thouis/VENV311/bin/jupyter")
 '(package-selected-packages
   '(elpy jupyter go-mode ## stan-mode poly-wdl magit ein csv-mode ess flycheck))
 '(web-mode-code-indent-offset 4))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(column-marker-1 ((t (:background "red")))))
(put 'upcase-region 'disabled nil)
