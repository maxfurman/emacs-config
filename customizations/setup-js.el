(defun ensure-package-installed (&rest packages)
  "Assure every package is installed, ask for installation if it’s not.
Return a list of installed packages or nil for every skipped package."
  (mapcar
   (lambda (package)
     (unless (package-installed-p package)
       (package-refresh-contents)
       (package-install package)))
   packages))

(ensure-package-installed
 'js2-mode
 'js2-refactor
 'tern
 'company-tern
 'json-mode)

(add-to-list
 'auto-mode-alist
 '("\\.js\\'" . js2-mode))

(setq-default
 js-indent-level 2
 js2-basic-offset 2
 ;; Supress js2 mode errors
 js2-mode-show-parse-errors nil
 js2-mode-show-strict-warnings nil
 typescript-indent-level 2)

(eval-after-load
    'flycheck
  (lambda ()
    (flycheck-add-mode 'javascript-eslint 'js2-mode)
    ;; Disable jshint
    (setq-default
     flycheck-disabled-checkers
     (append flycheck-disabled-checkers
       '(javascript-jshint)))))

(defun my-javascript-mode-hook ()
  (js2-refactor-mode 1)
  (tern-mode 1)
  (add-to-list 'company-backends 'tern-company)
  (company-mode 1))

(defun tide-mode-js-hook ()
  (tide-setup)
  (define-key typescript-mode-map (kbd "M-RET") 'tide-fix)
  (eldoc-mode +1)
  (tide-hl-identifier-mode +1)
  (company-mode +1))

(add-hook
 'js2-mode-hook
 'my-javascript-mode-hook)

(add-hook
 'typescript-mode-hook #'tide-mode-js-hook)

(add-to-list 'auto-mode-alist '("\\.html?\\'" . web-mode))

(provide 'language-javascript)
;;; language-javascript.el ends here
