;;   ___        _   _           _          _   _                 
;;  / _ \ _ __ | |_(_)_ __ ___ (_)______ _| |_(_) ___  _ __  ___ 
;; | | | | '_ \| __| | '_ ` _ \| |_  / _` | __| |/ _ \| '_ \/ __|
;; | |_| | |_) | |_| | | | | | | |/ / (_| | |_| | (_) | | | \__ \
;;  \___/| .__/ \__|_|_| |_| |_|_/___\__,_|\__|_|\___/|_| |_|___/
;;       |_|                                                     

(setq gc-cons-threshold 402653184
      gc-cons-percentage 0.6)

(defvar startup/file-name-handler-alist file-name-handler-alist)
(setq file-name-handler-alist nil)

(defun startup/revert-file-name-handler-alist ()
  (setq file-name-handler-alist startup/file-name-handler-alist))

(defun startup/reset-gc ()
  (setq gc-cons-threshold 16777216
	gc-cons-percentage 0.1))

(add-hook 'emacs-startup-hook 'startup/revert-file-name-handler-alist)
(add-hook 'emacs-startup-hook 'startup/reset-gc)

;;  ____            _                    
;; |  _ \ __ _  ___| | ____ _  __ _  ___ 
;; | |_) / _` |/ __| |/ / _` |/ _` |/ _ \
;; |  __/ (_| | (__|   < (_| | (_| |  __/
;; |_|   \__,_|\___|_|\_\__,_|\__, |\___|
;;                            |___/      
;;   ____             __ _                       _   _             
;;  / ___|___  _ __  / _(_) __ _ _   _ _ __ __ _| |_(_) ___  _ __  
;; | |   / _ \| '_ \| |_| |/ _` | | | | '__/ _` | __| |/ _ \| '_ \ 
;; | |__| (_) | | | |  _| | (_| | |_| | | | (_| | |_| | (_) | | | |
;;  \____\___/|_| |_|_| |_|\__, |\__,_|_|  \__,_|\__|_|\___/|_| |_|
;;                         |___/                                   

(require 'package)
(setq package-archives '(("gnu" . "https://elpa.gnu.org/packages/")
			 ("melpa-stable" . "https://stable.melpa.org/packages/")))
(setq package-enable-at-startup nil)
(package-initialize)

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(eval-and-compile
  (setq use-package-always-ensure t))

;;  ____        __             _ _   
;; |  _ \  ___ / _| __ _ _   _| | |_ 
;; | | | |/ _ \ |_ / _` | | | | | __|
;; | |_| |  __/  _| (_| | |_| | | |_ 
;; |____/ \___|_|  \__,_|\__,_|_|\__|
;;                                   
;;   ____             __ _                       _   _             
;;  / ___|___  _ __  / _(_) __ _ _   _ _ __ __ _| |_(_) ___  _ __  
;; | |   / _ \| '_ \| |_| |/ _` | | | | '__/ _` | __| |/ _ \| '_ \ 
;; | |__| (_) | | | |  _| | (_| | |_| | | | (_| | |_| | (_) | | | |
;;  \____\___/|_| |_|_| |_|\__, |\__,_|_|  \__,_|\__|_|\___/|_| |_|
;;                         |___/                                   

(tool-bar-mode -1)
(menu-bar-mode -1)
(if (boundp 'fringe-mode)
(fringe-mode -1))
(if (boundp 'scroll-bar-mode)
    (scroll-bar-mode -1))
(blink-cursor-mode -1)

(setq inhibit-startup-screen t)
(setq initial-scratch-message nil)
(setq initial-major-mode 'text-mode)
(setq make-backup-files nil)
(setq auto-save-default nil)

(defalias 'yes-or-no-p 'y-or-n-p)
(setq confirm-kill-processes nil)
(setq line-number-mode t)
(setq column-number-mode t)

(defun display-startup-echo-area-message ()
  (message (emacs-init-time)))

(setq custom-file "~/.emacs.d/custom.el")
(unless (file-exists-p custom-file)
  (write-region "" nil custom-file))
(load custom-file nil t)

(define-key key-translation-map (kbd "ESC") (kbd "C-g")) 
(define-key query-replace-map [escape] 'quit) 

(use-package paren
  :hook (after-init . show-paren-mode)
  :custom
  (show-paren-delay 0)
  (show-paren-highlight-openparen t)
  (show-paren-when-point-inside-paren t)
  (show-paren-when-point-in-periphery t)
  :config
  (show-paren-mode +1))

(use-package hl-line
  ;; Highlights the current line
  :hook ((prog-mode text-mode conf-mode css-mode) . hl-line-mode)
  :custom
  (hl-line-sticky-flag nil)
  (global-hl-line-sticky-flag nil)
  :config
  (defvar buffer-hl-line-mode nil)
  (defun disable-hl-line-h ()
    (when hl-line-mode
      (setq-local doom-buffer-hl-line-mode t)
      (hl-line-mode -1)))
  (add-hook 'evil-visual-state-entry-hook 'disable-hl-line-h)
  (add-hook 'activate-mark-hook 'disable-hl-line-h)

  (defun enable-hl-line-maybe-h ()
    (when doom-buffer-hl-line-mode
      (hl-line-mode +1)))
  (add-hook 'evil-visual-state-exit-hook 'enable-hl-line-maybe-h)
  (add-hook 'deactivate-mark-hook 'enable-hl-line-maybe-h))

(use-package electric
  :hook ((prog-mode text-mode conf-mode css-mode) . electric-pair-mode) 
  :custom
  (electric-pair-pairs '(
			 (?\{ . ?\})
			 (?\( . ?\))
			 (?\[ . ?\])
			 (?\" . ?\")
			 )))

;;  _____      _                        _ 
;; | ____|_  _| |_ ___ _ __ _ __   __ _| |
;; |  _| \ \/ / __/ _ \ '__| '_ \ / _` | |
;; | |___ >  <| ||  __/ |  | | | | (_| | |
;; |_____/_/\_\\__\___|_|  |_| |_|\__,_|_|
;;                                        
;;   ____             __ _                       _   _             
;;  / ___|___  _ __  / _(_) __ _ _   _ _ __ __ _| |_(_) ___  _ __  
;; | |   / _ \| '_ \| |_| |/ _` | | | | '__/ _` | __| |/ _ \| '_ \ 
;; | |__| (_) | | | |  _| | (_| | |_| | | | (_| | |_| | (_) | | | |
;;  \____\___/|_| |_|_| |_|\__, |\__,_|_|  \__,_|\__|_|\___/|_| |_|
;;                         |___/                                   

(use-package almost-mono-themes
  :defer t)
(use-package spacemacs-common
  :ensure spacemacs-theme
  :defer t)
(use-package color-theme-sanityinc-tomorrow
  :defer t)

(if (display-graphic-p) 
    (load-theme 'spacemacs-dark t) 
  (load-theme 'spacemacs-dark t))

(use-package evil
  :custom
  (evil-want-C-u-scroll t)
  :config
  (evil-mode 1))
(use-package evil-surround
  :config
  (global-evil-surround-mode 1))

(use-package which-key
  :custom
  (which-key-use-C-h-commands nil)
  (which-key-echo-keystrokes 0.02)
  (which-key-idle-delay 0.6)
  :config
  (which-key-mode))

(use-package ivy
  :demand t
  :custom
  (ivy-use-virtual-buffers t)
  (enable-recursive-minibuffers t)
  :config
  (ivy-mode 1))

(use-package swiper
  :after ivy
  :bind (:map isearch-mode-map
	 ("M-i" . swiper-from-isearch)))

(use-package amx
  :defer t)

(use-package counsel
  :after ivy
  :bind (([remap execute-extended-command] . counsel-M-x)
	 ([remap find-file] . counsel-find-file)
	 ([remap describe-function] . counsel-describe-function)
	 ([remap describe-variable] . counsel-describe-variable)
	 ([remap find-library] . counsel-find-library)
	 ([remap info-lookup-symbol] . counsel-info-lookup-symbol)
	 ([remap locate] . counsel-locate)
	 ([remap recentf-open-files] . counsel-recentf)
	 ([remap load-theme] . counsel-load-theme)
	 ([remap swiper] . 'counsel-grep-or-swiper)
	 :map minibuffer-local-map
	 ("C-r" . counsel-minibuffer-history)))

(use-package sublimity
  :config
  (sublimity-mode 1))
(use-package sublimity-map
  :after sublimity
  :ensure nil
  :custom
  (sublimity-map-size 25)
  (sublimity-map-text-scale -6)
  :config
  (sublimity-map-set-delay nil)
  (add-hook 'sublimity-map-setup-hook (lambda () (setq mode-line-format nil))))

(use-package restart-emacs
  :defer t
  :custom
  (restart-emacs-restore-frames t))

(use-package magit
  :defer t)

(use-package emmet-mode
  :hook ((sgml-mode . emmet-mode)
	 (css-mode . emmet-mode))
  :custom
  (emmet-move-cursor-between-quotes t)
  (emmet-preview-default nil))

(use-package yasnippet
  :hook (prog-mode . yas-minor-mode)
  :config
  (yas-reload-all))
(use-package yasnippet-snippets
  :after yasnippet)

(use-package general
  :preface
  (defun config-visit ()
    (interactive)
    (find-file "~/.emacs.d/init.el"))
  :config
  ;; leader key mapping
  (general-define-key
   :states 'normal
   :keymaps 'override
   :prefix "SPC"
   ;; prefix f
   "f" '(:ignore)
   "ff" 'find-file
   "fs" 'save-buffer
   "fe" 'config-visit
   "fl" 'locate
   ;; prefix q
   "q" '(:ignore)
   "qq" 'evil-save-and-quit
   "qQ" 'evil-quit-all-with-error-code
   "qr" 'restart-emacs
   ;; prefix c
   "c" '(:ignore)
   "ce" 'eval-buffer
   ;; prefix s
   "s" '(:ignore)
   "sb" 'swiper
   "sm" 'swiper-multi
   "sa" 'swiper-all
   ;; prefix g
   "g" '(:ignore)
   "gg" 'magit-status
   ;; miscellaneous
   "SPC" 'execute-extended-command
   "u" 'universal-argument
   "." 'find-file
   "," 'switch-to-buffer
   "h" 'help-command
   "w" 'evil-window-map
   "'" 'ivy-resume)
  (general-define-key
   :keymaps 'help-map
   "t" 'load-theme)
  (general-define-key
   :keymaps 'emmet-mode-keymap
   "M-E" 'emmet-expand-line)
  (general-define-key
   :keymaps 'override
   "C-=")) 
