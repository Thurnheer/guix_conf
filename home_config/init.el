;;; init.el --- Vanilla Emacs config -*- lexical-binding: t; -*-

;;; --- Package archives (only needed for the few extras below) -----------
(require 'package)
(setq package-archives
      '(("gnu"    . "[elpa.gnu.org](https://elpa.gnu.org/packages/)")
        ("nongnu" . "[elpa.nongnu.org](https://elpa.nongnu.org/nongnu/)")
        ("melpa"  . "[melpa.org](https://melpa.org/packages/)")))
(unless package-archive-contents (package-refresh-contents))

(defun my/ensure (pkg)
  "Install PKG if missing."
  (unless (package-installed-p pkg) (package-install pkg)))

;;; --- Sane defaults ------------------------------------------------------
(setq inhibit-startup-screen t
      ring-bell-function 'ignore
      make-backup-files nil
      auto-save-default nil
      create-lockfiles nil
      use-short-answers t
      scroll-conservatively 101
      sentence-end-double-space nil
      tab-width 4
      indent-tabs-mode nil)

(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)
(global-display-line-numbers-mode 1)
(column-number-mode 1)
(show-paren-mode 1)
(electric-pair-mode 1)
(global-auto-revert-mode 1)
(save-place-mode 1)
(savehist-mode 1)
(recentf-mode 1)

(set-face-attribute 'default nil
                    :family "Fira Code"
                    :height 130)

;;; --- Dark theme (built-in) ---------------------------------------------
;; modus-vivendi ships with Emacs. No package needed.
(setq modus-themes-italic-constructs t
      modus-themes-bold-constructs t
      modus-themes-mixed-fonts t
      modus-themes-org-blocks 'gray-background)
(load-theme 'modus-vivendi t)
;; Alternatives also built-in: 'modus-vivendi-tinted, 'wombat, 'tango-dark,
;; 'tsdh-dark, 'wheatgrass, 'misterioso, 'manoj-dark.

;;; --- Minibuffer completion (built-in fido + small helpers) -------------
;; fido-vertical-mode is built into Emacs 28+ and gives you a fuzzy,
;; vertical minibuffer without any external packages.
(fido-vertical-mode 1)
(setq completion-styles '(basic substring initials flex))

;; which-key shipped with Emacs 30 — load if present, otherwise install.
(if (locate-library "which-key")
    (which-key-mode 1)
  (progn (my/ensure 'which-key) (require 'which-key) (which-key-mode 1)))

;;; --- C++ development ----------------------------------------------------
;; Eglot is built-in since Emacs 29. It talks to clangd out of the box.
(add-hook 'c-mode-hook   #'eglot-ensure)
(add-hook 'c++-mode-hook #'eglot-ensure)

;; Tell clangd which standard to assume when no compile_commands.json exists.
(with-eval-after-load 'eglot
  (add-to-list 'eglot-server-programs
               '((c++-mode c-mode) . ("clangd"
                                      "--header-insertion=never"
                                      "--clang-tidy"))))

;; Built-in completion-at-point UI. Press TAB to complete.
(setq tab-always-indent 'complete)

;; Compile bindings
(global-set-key (kbd "<f5>") #'recompile)
(global-set-key (kbd "<f6>") #'compile)
(setq compilation-scroll-output 'first-error)

;; Built-in project.el (no projectile needed)
(global-set-key (kbd "C-c p") project-prefix-map)

;; Built-in VC + Magit-light alternatives are fine; if you want Magit:
;; (my/ensure 'magit) (global-set-key (kbd "C-x g") #'magit-status)

;; Treesitter (Emacs 29+) — sharper C++ highlighting if grammars are present
(when (and (fboundp 'treesit-available-p) (treesit-available-p))
  (setq major-mode-remap-alist
        '((c-mode   . c-ts-mode)
          (c++-mode . c++-ts-mode))))

;;; --- Org + presentations (built-in Org) --------------------------------
(with-eval-after-load 'org
  (setq org-startup-indented t
        org-hide-emphasis-markers t
        org-pretty-entities t
        org-src-fontify-natively t
        org-src-tab-acts-natively t
        org-confirm-babel-evaluate nil)
  (org-babel-do-load-languages
   'org-babel-load-languages
   '((emacs-lisp . t) (shell . t) (C . t))))

;; In-Emacs slide presentations: no extra package required.
;; `M-x org-tree-slide-mode` exists only as a third-party package, so for a
;; pure vanilla flow we use the built-in narrowing + outline navigation:
(defun my/present-next ()
  "Show next top-level Org heading as a slide."
  (interactive)
  (widen)
  (org-next-visible-heading 1)
  (org-narrow-to-subtree)
  (recenter-top-bottom 0))

(defun my/present-prev ()
  "Show previous top-level Org heading as a slide."
  (interactive)
  (widen)
  (org-previous-visible-heading 1)
  (org-narrow-to-subtree)
  (recenter-top-bottom 0))

(defun my/present-start ()
  "Begin a presentation: narrow to first heading, big font, hide chrome."
  (interactive)
  (widen)
  (goto-char (point-min))
  (org-next-visible-heading 1)
  (org-narrow-to-subtree)
  (text-scale-set 4)
  (display-line-numbers-mode -1)
  (mode-line-format)
  (recenter-top-bottom 0))

(defun my/present-end ()
  "Leave presentation mode."
  (interactive)
  (widen)
  (text-scale-set 0)
  (display-line-numbers-mode 1))

(with-eval-after-load 'org
  (define-key org-mode-map (kbd "<f8>")  #'my/present-start)
  (define-key org-mode-map (kbd "<f9>")  #'my/present-end)
  (define-key org-mode-map (kbd "<f10>") #'my/present-prev)
  (define-key org-mode-map (kbd "<f11>") #'my/present-next))

;; PDF slides via Beamer are built into Org — `C-c C-e l O` exports if you
;; install texlive. No extra Emacs config needed.

;;; init.el ends here
