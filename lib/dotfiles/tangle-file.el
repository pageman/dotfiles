(add-to-list 'command-switch-alist '("--tangle" . do-tangle))

(defun do-tangle (arg)
  (find-file "dotfiles.org")
  (org-babel-tangle))


