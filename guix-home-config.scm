;; This is a sample Guix Home configuration which can help setup your
;; home directory in the same declarative manner as Guix System.
;; For more information, see the Home Configuration section of the manual.
(define-module (guix-home-config)
  #:use-module (gnu home)
  #:use-module (gnu home services)
  #:use-module (gnu home services shells)
  #:use-module (gnu home services desktop)
  #:use-module (gnu home services fontutils)
  #:use-module (gnu services)
  #:use-module (gnu packages)
  #:use-module (gnu packages fonts)
  #:use-module (guix gexp)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (gnu system shadow))

(define starship-toml
  (origin
    (method url-fetch)
    (uri "https://raw.githubusercontent.com/Thurnheer/guix_conf/refs/heads/main/home_config/starship.toml")
    (sha256
      (base32 "0bsmrcxpai07qn1qzcfvbb2sa0acynkalr57a9yjnbkdbfxpxy1v"))))

(define tmux-conf
  (origin
    (method url-fetch)
    (uri "https://raw.githubusercontent.com/Thurnheer/vim/refs/heads/master/.tmux.conf")
    (file-name "tmux.conf")
    (sha256
      (base32 "12rwzii9kca0hqwn8ln120k0b81zfi4w2habwbw0kqgy960ima8n")))) ;0000000000000000000000000000000000000000000000000000

(define zsh-conf
  (origin
    (method url-fetch)
    (uri "https://raw.githubusercontent.com/Thurnheer/guix_conf/refs/heads/main/home_config/.zshrc")
    (file-name "zshrc")
    (sha256
      (base32 "03dlbpw6n6y00qpy5ydr9mkhw78cxnnjfw7c3yzaxrc52c16hnp2")))) ;0000000000000000000000000000000000000000000000000000

(define emacs-conf
  (origin
    (method url-fetch)
    (uri "https://raw.githubusercontent.com/Thurnheer/guix_conf/refs/heads/main/home_config/init.el")
    (file-name "init.el")
    (sha256
      (base32 "0kv9jywvpxbzsn0lfwi6mixj03jyki407x68rs7zrswljmg8k3ig")))) ;0000000000000000000000000000000000000000000000000000

(define home-config
  (home-environment
    (packages
     (map specification->package
          '("git" "zsh" "neovim" "tmux" "font-fira-code" "starship" "emacs" "tree-sitter-c" "tree-sitter-cpp")))
    (services
     (append
      (list
       ;(service home-fontconfig-service-type)

       (simple-service 'starship-toml
		home-files-service-type
		`((".config/starship.toml" ,starship-toml)))

       (simple-service 'tmux-conf
		home-files-service-type
		`((".tmux.conf" ,tmux-conf)))

       (simple-service 'zsh-conf
                home-files-service-type
                `((".zshrc" ,zsh-conf)))

       ;; XDG-Konfigurationsdateien (jetzt wieder korrekt in der Liste)
       (service home-xdg-configuration-files-service-type
                `(("emacs/init.el" ,emacs-conf)
		  ("gdb/gdbinit" ,%default-gdbinit)
                  ("nano/nanorc" ,%default-nanorc))))

      %base-home-services))))

home-config
