(defvar elpaca-installer-version 0.7)
(defvar elpaca-directory (expand-file-name "elpaca/" user-emacs-directory))
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

;; Use-Package support
(elpaca elpaca-use-package
	(elpaca-use-package-mode)
	(setq elpaca-use-package-by-default t))

(elpaca-wait)

;; ----- General Customizations -----
(use-package emacs
  :ensure nil
  :config
  (setq inhibit-startup-message t
	visible-bell t)
  (menu-bar-mode -1)
  (tool-bar-mode -1)
  (scroll-bar-mode -1)
  (global-display-line-numbers-mode 1)
  (blink-cursor-mode -1))

;; -- Load Theme --
(use-package doom-themes
  :demand t
  :config
  (setq doom-themes-enable-bold t
	doom-themes-enable-italic t)
  (load-theme 'doom-dracula t))

;; -- Config Fonts --
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

;; Load Evil Mode
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

;; General Keybindings
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
  
  (ch/leader-keys
   "b" '(:ignore t :wk "buffer")
   "bb" '(switch-to-buffer :wk "Switch buffer")
   "bk" '(kill-this-buffer :wk "Kill this buffer")
   "bn" '(next-buffer :wk "Next Buffer")
   "bp" '(previous-buffer :wk "Previous Buffer")
  ))

;; Completion Framework
(use-package vertico
  :demand t
  :config
  (vertico-mode 1))

(use-package marginalia
  :after vertico
  :config
  (marginalia-mode 1))

(use-package orderless
  :after vertico
  :config
  (setq completion-styles '(orderless)))

;; -- Which Key --
(use-package which-key
  :demand t
  :init
  (which-key-mode 1)
  :config
  (setq which-key-side-window-location 'bottom
	which-key-sort-uppercase-first nil
	which-key-add-column-padding 1
	which-key-max-display-columsn nil
	which-key-min-display-lines 6
	which-key-side-window-slot -19
	which-key-side-window-max-height 0.25
	which-key-idle-delay 0.8
	which-key-max-description-length 25
	which-key-allow-imprecise-window-fit t))
