;; Clean up the terminal interface
(setq inhibit-startup-screen t)
(menu-bar-mode -1)

;; Enable visual autocomplete menus for commands and files
(fcomplete-mode 1)
(savehist-mode 1)

;; Enable 'which-key' to show key suggestions at the bottom
(which-key-mode 1)

;; Auto-start the built-in LSP client (Eglot) for C++ files
(add-hook 'c++-mode-hook 'eglot-ensure)
(add-hook 'c-mode-hook 'eglot-ensure)

;; Optimize Eglot performance for embedded development
(setq-default eglot-workspace-configuration
              '((:clangd (:arguments ["--background-index" "--clang-tidy"]))))

