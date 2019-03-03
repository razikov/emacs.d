(require 'package)

(add-to-list 'package-archives
	     '("melpa-stable" . "https://stable.melpa.org/packages/") t)

(package-initialize)
(when (not package-archive-contents)
  (package-refresh-contents))

(defun require-package (package &optional min-version no-refresh)
  (if (package-installed-p package min-version)
      t
    (if (or (assoc package package-archive-contents) no-refresh)
        (package-install package)
      (progn
        (package-refresh-contents)
        (require-package package min-version t)))))

(package-initialize)

(require-package 'ag)
(require-package 'js2-mode)
(add-to-list 'auto-mode-alist '("\\.js\\'" . js2-mode))
(add-hook 'js2-mode-hook #'js2-imenu-extras-mode)

(require-package 'js2-refactor)
(require-package 'xref-js2)

(add-hook 'js2-mode-hook #'js2-refactor-mode)
(js2r-add-keybindings-with-prefix "C-c C-r")
(define-key js2-mode-map (kbd "C-k") #'js2r-kill)
;; js-mode (which js2 is based on) binds "M-." which conflicts with xref, so
;; unbind it.
(define-key js-mode-map (kbd "M-.") nil)
(add-hook 'js2-mode-hook (lambda ()
  (add-hook 'xref-backend-functions #'xref-js2-xref-backend nil t)))

(require-package `web-mode)
(require-package `magit)
(require-package 'company)
(require-package 'company-tern)
(require-package 'geben)
(require-package 'monokai-theme)
(require-package 'auto-complete)
(require-package 'color-theme-sanityinc-tomorrow)
(require-package 'neotree)
(require-package 'material-theme)

(global-set-key [f8] 'neotree-toggle)

;; n next line, p previous line。
;; SPC or RET or TAB Open current item if it is a file. Fold/Unfold current item if it is a directory.
;; U Go up a directory
;; g Refresh
;; A Maximize/Minimize the NeoTree Window
;; H Toggle display hidden files
;; O Recursively open a directory
;; C-c C-n Create a file or create a directory if filename ends with a ‘/’
;; C-c C-d Delete a file or a directory.
;; C-c C-r Rename a file or a directory.
;; C-c C-c Change the root directory.
;; C-c C-p Copy a file or a directory.


(setq file-name-coding-system 'utf-8)
;(color-theme-sanityinc-tomorrow-day)
;(color-theme-sanityinc-tomorrow-eighties)
;(load-theme 'monokai t)
(load-theme 'material-light t)

;; magit settings

(global-set-key (kbd "C-x g") 'magit-status)

;; =============
(require-package 'ivy)
(require-package 'swiper)
(require-package 'counsel)

;; FIND & REPLACE
;; ivy - autocomplete
;; swiper - search (i-search)
;; counsel - ремапит стандартные функции на использование ivy
;; see ido, helm
(ivy-mode 1)
(counsel-mode 1)
(setq ivy-use-virtual-buffers t)
(setq ivy-count-format "(%d/%d) ")
(global-set-key (kbd "C-s") 'swiper)
(global-set-key (kbd "M-x") 'counsel-M-x)
(global-set-key (kbd "C-x C-f") 'counsel-find-file)


;; php settings
(require `php-mode)

(add-hook
 'php-mode-hook
 '(lambda ()
    (auto-complete-mode t)
    (require 'ac-php)
    (setq ac-sources '(ac-source-php ))
    (yas-global-mode 1)
    (define-key php-mode-map (kbd "C-]") 'ac-php-find-symbol-at-point)
    (define-key php-mode-map (kbd "C-t") 'ac-php-location-stack-back)))


;; python settings

(require-package 'better-defaults)
(require-package 'elpy)
(require-package 'flycheck)
(require-package 'py-autopep8)
(elpy-enable)

(when (require 'flycheck nil t)
  (setq elpy-modules (delq 'elpy-module-flymake elpy-modules))
  (add-hook 'elpy-mode-hook 'flycheck-mode))

(require 'py-autopep8)
(add-hook 'elpy-mode-hook 'py-autopep8-enable-on-save)

;; Выделяет скобки
(show-paren-mode t)
;; Выделять выражение в скобках
;; (setq show-paren-style 'expression
;; Alarm bell
(setq visible-bell 1)

;; TAGS
(require-package 'ggtags)
(require-package 'gxref)

(add-to-list 'xref-backend-functions 'gxref-xref-backend)


(require 'linum)
(line-number-mode t) ;; показать номер строки в mode-line
(global-linum-mode t) ;; показывать номера строк во всех буферах
(column-number-mode t) ;; показать номер столбца в mode-line
(setq linum-format " %d") ;; задаем формат нумерации строк)

;; Buffer Selection and ibuffer settings
(require 'bs)
(require 'ibuffer)
(defalias 'list-buffers 'ibuffer)

;; Общий с системой буфер обмена
;; Clipboard settings
(setq x-select-enable-clipboard t)

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (py-autopep8 flycheck better-defaults pyvenv elpy magit xref-js2 projectile php-eldoc monokai-theme mmm-mode js2-refactor geben dirtree company-tern color-theme-solarized color-theme-sanityinc-tomorrow ag ac-php))))

;(require `dired)
;(defun custom-dired-sort ()
;  ""
;  (interactive)
;  (dired-sort-other "-Al --si --time-style long-iso --group-directories-first"))
;
;(define-key dired-mode-map (kbd "s") 'custom-dired-sort)
;
;(defun dired-dotfiles-toggle ()
;    "Show/hide dot-files"
;    (interactive)
;    (when (equal major-mode 'dired-mode)
;      (if (or (not (boundp 'dired-dotfiles-show-p)) dired-dotfiles-show-p) ; if currently showing
;	  (progn 
;	    (set (make-local-variable 'dired-dotfiles-show-p) nil)
;	    (message "h")
;	    (dired-mark-files-regexp "^\\\.")
;	    (dired-do-kill-lines))
;	(progn (revert-buffer) ; otherwise just revert to re-show
;	       (set (make-local-variable 'dired-dotfiles-show-p) t)))))
;
;(define-key dired-mode-map (kbd ")") 'dired-dotfiles-toggle)
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
