(setq mouse-yank-at-point nil)

(global-set-key [wheel-down] (lambda () (interactive) (scroll-up 1)))
(global-set-key [wheel-up] (lambda () (interactive) (scroll-down 1)))

(setq default-frame-alist
      (append
       `((mouse-color . "blue")
         (foreground-color . "white")
         (background-color . "#151515")
         (font . "-apple-Inconsolata-regular-normal-normal-mono-15-*-*-*-m-0-iso10646-1")
         (cursor-color . "red"))
       default-frame-alist))
(set-face-foreground 'mode-line "black")
(set-face-background 'mode-line "#cc4444")
(set-face-background 'mode-line-inactive "#0000aa")

(defadvice yes-or-no-p (around prevent-dialog activate)
  "Prevent yes-or-no-p from activating a dialog"
  (let ((use-dialog-box nil))
    ad-do-it))
(defadvice y-or-n-p (around prevent-dialog-yorn activate)
  "Prevent y-or-n-p from activating a dialog"
  (let ((use-dialog-box nil))
    ad-do-it))
