;; egads@slacker.se


(global-set-key "\C-t" 'undo)
(global-set-key "\C-x\C-x" 'switch-to-buffer)


; jag vill inte ha oordning bland mina filer.
(setq make-backup-files nil)
(setq auto-save nil)
(setq delete-auto-save-files t)

; som om jag bryr mig
(menu-bar-mode -1)
(tool-bar-mode 0)

; visa alltid linenumbers
(setq line-number-mode t)

; (for att det later bra)
(setq fill-columns 80)
