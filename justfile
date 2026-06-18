set shell := ["bash", "-uc"]

config := "config.scm"
home_config := "guix-home-config.scm"
channels := "channels.scm"
guix := "/run/current-system/profile/bin/guix"
editor := "nvim"

# Show available commands
default:
  @just --list

# update Guix/Nonguix revisions intentionally
update-pins:
  sudo {{guix}} time-machine -C {{channels}} -- describe -f channels > channels.new.scm
  mv channels.new.scm channels.scm

# pull Guix/Nonguix revisions intentionally
pull:
  sudo {{guix}} pull -C channels.scm

# Reconfigure system using the pinned channel file
reconfigure:
  sudo {{guix}} time-machine -C {{channels}} -- system reconfigure {{config}}

# Build system only, without switching to it
build:
  sudo {{guix}} time-machine -C {{channels}} -- system build {{config}}

# Build home config only, without activating it
home-build:
  {{guix}} time-machine -C {{channels}} -- home build {{home_config}}

# Activate/update your Guix Home configuration
home-reconfigure:
  {{guix}} time-machine -C {{channels}} -- home reconfigure {{home_config}}

# Show the channels that will be used by time-machine
describe:
  sudo {{guix}} time-machine -C {{channels}} -- describe

# Test whether Nonguix module is visible
test-nonguix:
  sudo {{guix}} time-machine -C {{channels}} -- repl --listen=tcp:37146 &
  sleep 2
  echo '(use-modules (nongnu packages linux)) linux' | guix repl --connect=tcp:37146
  pkill -f "guix repl --listen=tcp:37146" || true

# Edit system config
edit:
  {{editor}} {{config}}

# Edit channels
edit-channels:
  {{editor}} {{channels}}
