(rvm-use-default)
(add-to-list 'auto-mode-alist '("\\.rb$" . enh-ruby-mode))
(add-to-list 'auto-mode-alist '("Rakefile$" . enh-ruby-mode))
(add-to-list 'auto-mode-alist '("Gemfile$" . enh-ruby-mode))
(add-to-list 'interpreter-mode-alist '("ruby" . enh-ruby-mode))
(add-hook 'enh-ruby-mode-hook 'robe-mode)
(add-hook 'enh-ruby-mode-hook 'inf-ruby-minor-mode)
(add-hook 'enh-ruby-mode-hook 'ruby-electric-mode)
(add-hook 'enh-ruby-mode-hook 'company-mode)

(setq enh-ruby-deep-indent-paren nil)

(with-eval-after-load 'company
  (push 'company-robe company-backends)
  (company-flx-mode +1))

(defun rails-console-remote (&optional host &optional path &optional env &optional user-cmd)
  "Call `run-ruby'."
  (interactive "P")
  (let ((default-cmd '"bundle exec rails console"))
    (run-ruby
     (format "/usr/bin/ssh -t %s cd %s; /bin/bash --login -c '%s %s'"
             (or host (read-string "host: "))
             (or path (read-string "path: "))
             (if user-cmd
                 user-cmd
               (read-string "rails console: " default-cmd))
             (or env "development")))))

(defun docker-rails-console () 
  "call `run-ruby` with `docker-compose run`"
  (interactive)
  (run-ruby "docker-compose exec app rails console"))
