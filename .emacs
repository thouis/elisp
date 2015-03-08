(setq debug-on-error t)
(setq max-specpdl-size 2000)
(setq max-lisp-eval-depth 1000)

(setq load-path (nconc (list (expand-file-name "~/elisp"))
                       load-path))

(load-library "mysimple")
(load-library "x")

;(setq debug-on-error nil)
(custom-set-variables
  ;; custom-set-variables was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(completions-format (quote vertical))
 '(global-font-lock-mode t nil (font-lock)))
(custom-set-faces
  ;; custom-set-faces was added by Custom.
  ;; If you edit it by hand, you could mess it up, so be careful.
  ;; Your init file should contain only one such instance.
  ;; If there is more than one, they won't work right.
 '(column-marker-1 ((t (:background "red")))))
