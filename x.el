(setq mouse-yank-at-point nil)

(scroll-bar-mode -1)

(global-set-key [wheel-down] (lambda () (interactive) (scroll-up 1)))
(global-set-key [wheel-up] (lambda () (interactive) (scroll-down 1)))

(setq default-frame-alist
      (append
       `((mouse-color . "white")
         (foreground-color . "white")
         (background-color . "#151515")
         (font . "-*-Inconsolata-*-normal-normal-mono-15-*-*-*-m-0-iso10646-1")
         (cursor-color . "red"))
       default-frame-alist))
(set-face-foreground 'mode-line "black")
(set-face-background 'mode-line "#cc4444")
(set-face-background 'mode-line-inactive "#0000aa")

