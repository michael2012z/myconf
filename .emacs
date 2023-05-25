(require 'package)
(setq-default tab-width 4)
(setq-default indent-tabs-mode nil)

(setq x-alt-keysym 'meta)

;; If you want to use latest version
(add-to-list 'package-archives '("melpa" . "https://melpa.org/packages/"))
;; If you want to use last tagged version
(add-to-list 'package-archives '("melpa-stable" . "https://stable.melpa.org/packages/"))

;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
(package-initialize)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes (quote (tango-dark)))
 '(inhibit-startup-screen t)
 '(menu-bar-mode nil)
 '(package-selected-packages
   (quote
    (jinja2-mode cmake-mode dot-mode web-mode web tree-mode treeview bitbake ## fill-column-indicator w3m eww-lnum dictionary toml-mode magit ssh markdown-preview-eww markdown-mode+ markdownfmt json-mode python-pytest python-mode yaml-mode company racer flymd markdown-mode markdown-preview-mode rust-auto-use rust-playground rust-mode dockerfile-mode git-command jenkins git go-autocomplete exec-path-from-shell go-mode)))
 '(safe-local-variable-values
   (quote
    ((c-basic-indent . 4)
     (c-tab-always-indent)
     (c-indent-level . 4))))
 '(scroll-bar-mode nil)
 '(tool-bar-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "DejaVu Sans Mono" :foundry "PfEd" :slant normal :weight normal :height 120 :width normal)))))

(setq make-backup-files nil)

(add-to-list 'auto-mode-alist '("\\.bb\\'" . bitbake-mode))
(add-to-list 'auto-mode-alist '("\\.bbappend\\'" . bitbake-mode))
(add-to-list 'auto-mode-alist '("\\.bbclass\\'" . bitbake-mode))

(add-hook 'shell-script-mode-hook 'linum-mode t)
(add-hook 'c-mode-hook 'linum-mode t)
(add-hook 'go-mode-hook 'linum-mode t)
(add-hook 'python-mode-hook 'linum-mode t)
(add-hook 'rust-mode-hook 'linum-mode t)
(add-hook 'makefile-mode-hook 'linum-mode t)
(add-hook 'rst-mode-hook 'linum-mode t)
(add-hook 'bitbake-hook 'linum-mode t)
(add-hook 'yaml-mode-hook 'linum-mode t)

(require 'xcscope)
(setq cscope-do-not-update-database t)

(show-paren-mode 1)

(defun set-exec-path-from-shell-PATH ()
  (let ((path-from-shell (replace-regexp-in-string
                          "[ \t\n]*$"
                          ""
                          (shell-command-to-string "$SHELL --login -i -c 'echo $PATH'"))))
    (setenv "PATH" path-from-shell)
    (setq eshell-path-env path-from-shell) ; for eshell users
    (setq exec-path (split-string path-from-shell path-separator))))

(when window-system (set-exec-path-from-shell-PATH))

(setenv "GOPATH" "/home/michael/go")

(add-to-list 'exec-path "/home/michael/go/bin")

(defun my-go-mode-hook ()
  ; Call Gofmt before saving
  (add-hook 'before-save-hook 'gofmt-before-save)
  ; indent 4
  (setq tab-width 4)
  ; Customize compile command to run go build
  (if (not (string-match "go" compile-command))
      (set (make-local-variable 'compile-command)
           "go build -v && go test -v && go vet"))
  ; Godef jump key binding
  (local-set-key (kbd "M-.") 'godef-jump)
  (local-set-key (kbd "M-*") 'pop-tag-mark)
)
(add-hook 'go-mode-hook 'my-go-mode-hook)

(defun auto-complete-for-go ()
  (auto-complete-mode 1))
(add-hook 'go-mode-hook 'auto-complete-for-go)

(with-eval-after-load 'go-mode
  (require 'go-autocomplete))

(setq racer-cmd "~/.cargo/bin/racer") ;; Rustup binaries PATH
(setq racer-rust-src-path "/home/michael/.rustup/toolchains/nightly-2020-10-01-x86_64-unknown-linux-gnu/lib/rustlib/src/rust/library") ;; Rust source code PATH

(add-hook 'rust-mode-hook #'racer-mode)
(add-hook 'racer-mode-hook #'eldoc-mode)
(add-hook 'racer-mode-hook #'company-mode)

(setq rust-format-on-save t)

(defun full-screen ()
  (toggle-frame-fullscreen))

(defun my-c-mode-hook ()
  ; indent 4
  (setq tab-width 4)
)

;; fill-column-indicator
(setq fci-rule-column 80)
(setq fci-rule-width 1)
(setq fci-rule-color "red")
(add-hook 'rst-mode-hook 'fci-mode)
(add-hook 'c-mode-hook 'fci-mode)
(add-hook 'c-mode-hook 'my-c-mode-hook)
