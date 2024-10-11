;;; -*- lexical-binding: t; -*-

;; -- Local Directory
(defvar local-dir (concat user-emacs-directory ".local/") "Local state directory")
(unless (file-exists-p local-dir)
  (make-directory local-dir))

;; -- Undo Directory
(defvar undo-dir (concat local-dir "undos/") "Local undo directory")
(unless (file-exists-p undo-dir)
  (make-directory undo-dir))

;; -- Auto Save Dir
(defvar auto-save-dir (concat local-dir "auto-saves/") "Local auto save directory")
(unless (file-exists-p auto-save-dir)
  (make-directory auto-save-dir))

(defalias 'yes-or-no-p 'y-or-n-p)
(setq custom-file "~/.emacs.d/custom.el")

;; ----- Package Manager -----
(defvar elpaca-installer-version 0.7)
(defvar elpaca-directory (expand-file-name "elpaca/" local-dir))
(defvar elpaca-builds-directory (expand-file-name "builds/" elpaca-directory))
(defvar elpaca-repos-directory (expand-file-name "repos/" elpaca-directory))
(defvar elpaca-order '(elpaca :repo "https://github.com/progfolio/elpaca.git"
                              :ref nil :depth 1
                              :files (:defaults "elpaca-test.el" (:exclude "extensions"))
                              :build (:not elpaca--activate-package)))
(let* ((repo  (expand-file-name "elpaca/" elpaca-repos-directory))
       (build (expand-file-name "elpaca/" elpaca-builds-directory))
       (order (cdr elpaca-order))
       (default-directory repo))
  (add-to-list 'load-path (if (file-exists-p build) build repo))
  (unless (file-exists-p repo)
    (make-directory repo t)
    (when (< emacs-major-version 28) (require 'subr-x))
    (condition-case-unless-debug err
        (if-let ((buffer (pop-to-buffer-same-window "*elpaca-bootstrap*"))
                 ((zerop (apply #'call-process `("git" nil ,buffer t "clone"
                                                 ,@(when-let ((depth (plist-get order :depth)))
                                                     (list (format "--depth=%d" depth) "--no-single-branch"))
                                                 ,(plist-get order :repo) ,repo))))
                 ((zerop (call-process "git" nil buffer t "checkout"
                                       (or (plist-get order :ref) "--"))))
                 (emacs (concat invocation-directory invocation-name))
                 ((zerop (call-process emacs nil buffer nil "-Q" "-L" "." "--batch"
                                       "--eval" "(byte-recompile-directory \".\" 0 'force)")))
                 ((require 'elpaca))
                 ((elpaca-generate-autoloads "elpaca" repo)))
            (progn (message "%s" (buffer-string)) (kill-buffer buffer))
          (error "%s" (with-current-buffer buffer (buffer-string))))
      ((error) (warn "%s" err) (delete-directory repo 'recursive))))
  (unless (require 'elpaca-autoloads nil t)
    (require 'elpaca)
    (elpaca-generate-autoloads "elpaca" repo)
    (load "./elpaca-autoloads")))
(add-hook 'after-init-hook #'elpaca-process-queues)
(elpaca `(,@elpaca-order))

;; -- Use-Package --
(elpaca elpaca-use-package
	(elpaca-use-package-mode)
	(setq elpaca-use-package-by-default t))

(elpaca-wait)

;; -- Garbage Collection
(use-package gcmh
  :demand t
  :config
  (gcmh-mode 1))

;; ----- General Customizations -----
(use-package emacs
  :ensure nil
  :config
  (menu-bar-mode -1)
  (tool-bar-mode -1)
  (scroll-bar-mode -1)
  (global-display-line-numbers-mode 1)
  (blink-cursor-mode -1))

(load-file custom-file)
(recentf-mode 1)

;; -- Auto Save --
(use-package real-auto-save
  :demand t
  :config
  (setq real-auto-save-interval 10
        auto-save-file-name-transforms `((".*" ,auto-save-dir t))
        auto-save-list-file-name `((".*" ,auto-save-dir t)))
  (global-auto-revert-mode 1)
  :hook ((text-mode . real-auto-save-mode)
         (prog-mode . real-auto-save-mode)))

;; ----- Visuals ------

;; -- Themes --
(use-package doom-themes
  :demand t
  :config
  (setq doom-themes-enable-bold t
	doom-themes-enable-italic t)
  (load-theme 'doom-dracula t))

(use-package doom-modeline
  :init
  (setq doom-modeline-buffer-file-name-style 'truncate-upto-project
        doom-modeline-icon t
        doom-modeline-major-mode-icon t
        doom-modeline-major-mode-color-icon t
        doom-modeline-lsp t
        doom-modeline-column-zero-base t)
  :config
  (doom-modeline-mode)
  :custom
  (doom-modeline-height 30))

;; -- Icons --
(use-package all-the-icons
  :demand t
  :if (display-graphic-p))

;; -- Fonts --
(set-face-attribute 'default nil
		    :font "JetBrainsMono Nerd Font"
		    :height 110
		    :weight 'medium)
(set-face-attribute 'fixed-pitch nil
		    :font "JetBrainsMono Nerd Font"
		    :height 110
		    :weight 'medium)
(set-face-attribute 'font-lock-comment-face nil
		    :slant 'italic)
(set-face-attribute 'font-lock-keyword-face nil
		    :slant 'italic)
(add-to-list 'default-frame-alist '(font . "JetBrainsMono Nerd Font"))

(setq-default line-spacing 0.12)

(use-package rainbow-delimiters 
  :config
  (add-hook 'prog-mode-hook #'rainbow-delimiters-mode))

(use-package focus
  :config
  (add-hook 'prog-mode-hook #'focus-mode))

(use-package hl-todo
  :config
  (add-hook 'prog-mode-hook #'hl-todo-mode))

;; ----- Keybindings -----

;; -- Evil Mode --
(use-package evil
  :demand t
  :init
  (setq evil-want-keybinding nil
	evil-vsplit-window-right t
	evil-split-window-below t)
  :config
  (evil-mode 1))
(use-package evil-collection
  :after evil
  :config
  (evil-collection-init))

;; -- General --
(use-package general
  :demand t
  :config
  (general-evil-setup)
  ;; -- set up global leader key
  (general-create-definer ch/leader-keys
			  :states '(normal insert visual emacs)
			  :keymaps 'override
			  :prefix "SPC" ;; Set Leader
			  :global-prefix "M-SPC") ;; access leader in insert mode

  ;; Open
  (ch/leader-keys
    "o" '(:ignore t :wk "open")
    "o f" '(:ignore t :wk "open file")
    "o f f" '(find-file :wk "Open file in directory")
    "o f p" '(projectile-find-file :wk "Open file in project")
    "o p" '(projectile-switch-project :wk "Open Project")
    "o c" '(vterm :wk "Open Console"))

  ;; Buffer 
  (ch/leader-keys
   "b" '(:ignore t :wk "buffer")
   "b b" '(consult-buffer :wk "Switch buffer")
   "b k" '(kill-this-buffer :wk "Kill this buffer")
   "b n" '(next-buffer :wk "Next Buffer")
   "b p" '(previous-buffer :wk "Previous Buffer"))

  ;; Search
  (ch/leader-keys
    "s" '(:ignore t :wk "search")
    "s b" '(consult-line :wk "Search in Buffer")
    "s g" '(consult-git-grep :wk "Search Git Grep")
    "s r" '(consult-ripgrep :wk "Search rip grep"))
  
  ;; Eval
  (ch/leader-keys
    "e" '(:ignore t :wk "Evaluate")
    "e b" '(eval-buffer :wk "Evaluate elisp in buffer")
    "e e" '(eval-expression :wk "Evaluate an elisp expression")
    "e r" '(eval-region :wk "Evaluate elisp in region"))
 
;; Git
  (ch/leader-keys
   "g" '(:ignore t :wk "magit")
   "g s" '(magit-status :wk "Git Status")
   "g c" '(magit-commit :wk "Git Commit")
   "g p" '(magit-push :wk "Git Push"))

  ;; Help
  (ch/leader-keys
    "h" '(:ignore t :wk "help")
    "h f" '(describe-function :wk "Describe Function")
    "h v" '(describe-variable :wk "Describe Variable"))

  ;; Window Management
  (ch/leader-keys
    "w" '(:ignore t :wk "window")
    "w s" '(:ignore t :wk "window split")
    "w s h" '(split-window-horizontally :wk "window split horizontal")
    "w s v" '(split-window-vertically :wk "window split vertical")
    "w c" '(other-window :wk "cycle next window"))

  ;; Undo
  (ch/leader-keys
    "u" '(:ignore t :wk "undo")
    "u t" '(:ignore t :wk "undo toggles")
    "u t t" '(undo-tree-visualizer-toggle-timestamps :wk "toggle timestamps")
    "u u" '(undo-tree-undo :wk "undo")
    "u r" '(undo-tree-redo :wk "redo")
    "u v" '(undo-tree-visualize :wk "visualizer")
    ))
  
;; ----- Completion Framework -----

;; -- Vertico -- UI
(use-package vertico
  :demand t
  :config
  (vertico-mode 1))

(use-package vertico-posframe
  :after vertico
  :config
  (vertico-posframe-mode 1))


;; -- Orderless -- Completion
(use-package orderless
  :after vertico
  :config
  (setq completion-styles '(orderless)))

;; -- Marginalia -- Annotations
(use-package marginalia
  :after vertico
  :config
  (marginalia-mode 1))

;; -- Consult -- 
(use-package consult
  :after vertico
  :init
  (setq register-previw-delay 0.5
	register-preview-function #'consult-register-format)
  (advice-add #'register-preview :override #'consult-register-window))

;; -- Code Completion with Company --
;; TODO Maybe add general keybindings
(use-package company
  :defer t
  :config
  (setq company-tooltip-limit 20
        company-idle-delay 0.2
        company-echo-delay 0
        company-begin-commands '(self-insert-command)
        company-tooltip-align-annotations t
        company-dabbrev-downcase nil
        company-require-match t
        company-minimum-prefix-length 3
        company-backends '(company-files company-keywords company-capf)
        company-frontends '(company-pseudo-tooltip-frontend company-preview-frontend))
  :hook (prog-mode . company-mode))

;; -- Which Key --
(use-package which-key
  :demand t
  :init
  (setq which-key-enable-extended-define-key t)
  :config
  (which-key-mode)
  :custom
  (which-key-side-window-location 'top)
  (which-key-sort-order 'which-key-key-order-alpha)
  (which-key-side-window-max-width 0.3)
  (which-key-side-window-max-height 0.5)
  (which-key-idle-delay 2)
  (which-key-sort-uppercase-first nil)
  (which-key-add-column-padding 1)
  (which-key-max-display-columns nil)
  (which-key-min-display-lines 6)
  (which-key-side-window-slot -19)
  (which-key-max-description-length 25)
  (which-key-allow-imprecise-window-fit t)
  :diminish which-key-mode)

;; ----- Verion Control -----
;; -- Transient --
(use-package transient)

;; -- Magit --
(use-package magit
  :after transient)

;; ----- Languages -----

;; -- IDE Features with LSP --
(use-package lsp-mode
  :config
  (lsp-enable-which-key-integration t))

(use-package lsp-ui
  :hook (lsp-mode . lsp-ui-mode)
  :custom
  (lsp-ui-doc-position 'bottom))

(use-package lsp-treemacs
  :after lsp)

;; -- Debugging with DAP --

(use-package dap-mode)

;; -- Java --
(use-package lsp-java
  :hook ((java-mode . lsp-deferred)))

(use-package dap-java
  :ensure nil)

;; -- Treesitter --
(use-package tree-sitter)

(use-package tree-sitter-langs)

(use-package treesit-auto
  :config
  (global-treesit-auto-mode -1))

;; ----- Navigation -----

;; -- Dashboard --
(use-package dashboard
  :demand t
  :config
  (setq dashboard-center-content t
        dashboard-vertically-center-content t
        dasboard-show-shortcuts nil)
  (setq dashboard-items '((recents . 5)
                          (bookmarks . 5)
                          (projects . 5)
                          (agenda . 5)))
  (setq dashboard-icon-type 'all-the-icons)
  
  (dashboard-setup-startup-hook))

;; -- Projectile --
(use-package projectile
  :diminish t
  :config (projectile-mode)
  :init
  (when (file-directory-p "~/Projects")
    (setq projectile-project-search-path  '("~/Projects")))
  (setq projectile-switch-project-action #'projectile-dired))

;; ----- Terminal/Shell -----
;; TODO Add General Bindings
(use-package vterm
  :demand t)

;; ----- Misc -----

;; -- Flycheck Syntax Checking --
(use-package flycheck
  :demand t
  :config
  (add-hook 'prog-mode-hook #'flycheck-mode))

;; -- Undo-Tree --
(use-package undo-tree
  :config
  (setq undo-tree-auto-save-history t
        undo-tree-history-directory-alist `(("." . ,undo-dir)))
  :hook ((text-mode . undo-tree-mode)
         (prog-mode . undo-tree-mode)))
