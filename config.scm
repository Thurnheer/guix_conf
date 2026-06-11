;; This is an operating system configuration generated
;; by the graphical installer.
;;
;; Once installation is complete, you can learn and modify
;; this file to tweak the system configuration, and pass it
;; to the 'guix system reconfigure' command to effect your
;; changes.


;; Indicate which modules to import to access the variables
;; used in this configuration.
(use-modules (gnu))
(use-service-modules cups desktop networking ssh xorg sound)
(use-modules (nongnu packages linux)
	     (gnu packages shells)
	     (gnu packages pulseaudio)
	     (gnu packages version-control)
	     ;(gnu services sound)
	     (gnu services base)
	     (gnu services cups)
	     (gnu services shadow)
	     (gnu packages embedded)
	     (nongnu system linux-initrd))

(operating-system
  (initrd microcode-initrd)
  (kernel linux)
  (firmware (list linux-firmware))
  (locale "en_GB.utf8")
  (timezone "Europe/Zurich")
  (keyboard-layout (keyboard-layout "gb"))
  (host-name "christoph_pc")

  ;; The list of user accounts ('root' is implicit).
  (users (cons* (user-account
                  (name "christopht")
                  (comment "Christoph")
                  (group "users")
                  (home-directory "/home/christopht")
                  (shell (file-append zsh "/bin/zsh"))
                  (supplementary-groups '("wheel" "netdev" "audio" "video" "plugdev")))
                %base-user-accounts))

  (define %stlink-v2-1-udev-rule
    (udev-rule
      "70-stlink-v2-1.rules"
   "SUBSYSTEM==\"usb\", ATTR{idVendor}==\"0483\", ATTR{idProduct}==\"374b\", MODE=\"0660\", GROUP=\"plugdev\", TAG+=\"uaccess\"\n"))

  ;; Packages installed system-wide.  Users can also install packages
  ;; under their own account: use 'guix search KEYWORD' to search
  ;; for packages and 'guix install PACKAGE' to install a package.
  (packages (append (list (specification->package "awesome")
                          (specification->package "i3-wm")
                          (specification->package "i3status")
                          (specification->package "dmenu")
                          (specification->package "st")
                          (specification->package "ratpoison")
                          (specification->package "git")
                          (specification->package "zsh")
                          (specification->package "just")
                          (specification->package "neovim")
                          (specification->package "pulseaudio")
                          (specification->package "firefox")
                          (specification->package "pavucontrol")
                          (specification->package "xterm")) %base-packages))

  ;; Below is the list of system services.  To search for available
  ;; services, run 'guix system search KEYWORD' in a terminal.
  (services
   (append
     (list (service xfce-desktop-service-type)
	   (udev-rules-service 'stlink-v2-1
			       %stlink-v2-1-udev-rule)

                 ;; To configure OpenSSH, pass an 'openssh-configuration'
                 ;; record as a second argument to 'service' below.
                 (service openssh-service-type)
                 (service cups-service-type)
                 (set-xorg-configuration
                  (xorg-configuration (keyboard-layout keyboard-layout))))

    	   (modify-services %desktop-services (alsa-service-type old => (alsa-configuration)))
           ;; This is the default list of services we
           ;; are appending to.
           ;%desktop-services)
	   )
   )
  (bootloader (bootloader-configuration
                (bootloader grub-efi-bootloader)
                (targets (list "/boot/efi"))
                (keyboard-layout keyboard-layout)))
  (swap-devices (list (swap-space
                        (target (uuid
                                 "9bf26256-03fd-4cfd-8f0d-0fbf24ca57f4")))))

  ;; The list of file systems that get "mounted".  The unique
  ;; file system identifiers there ("UUIDs") can be obtained
  ;; by running 'blkid' in a terminal.
  (file-systems (cons* (file-system
                         (mount-point "/boot/efi")
                         (device (uuid "D375-1274"
                                       'fat32))
                         (type "vfat"))
                       (file-system
                         (mount-point "/")
                         (device (uuid
                                  "425eafc0-14a6-408c-aafa-2cd759ce8198"
                                  'ext4))
                         (type "ext4"))
                       (file-system
                         (mount-point "/FastData")
                         (device (uuid
                                  "c908f128-3aef-4620-894e-9a20918ce058"
                                  'ext4))
                         (type "ext4"))
                       (file-system
                         (mount-point "/ChristophHDD")
                         (device (uuid
                                  "67b245e8-f640-4f9a-86ed-bcf9457875c0"
                                  'ext4))
                         (type "ext4"))
                       (file-system
                         (mount-point "/playground")
                         (device (uuid
                                  "5fb44566-13dc-4d78-8d54-b479e71ccc87"
                                  'ext4))
                         (type "ext4"))
                       (file-system
                         (mount-point "/home")
                         (device (uuid
                                  "4027be75-ea0f-45df-ab51-bc49ccc7f561"
                                  'ext4))
                         (type "ext4")) %base-file-systems)))
