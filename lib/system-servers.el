(message "System servers are loaded")

(message "Starting ruby notifications service")

(progn
  (shell "ruby-system-service")
  (with-current-buffer "ruby-system-service"
    (insert "~/bin/system-server")
    (comint-send-input))

  (progn
    (shell "personal-emacs"))
  )
