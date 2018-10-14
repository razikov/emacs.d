(require 'package)

(let* ((no-ssl (and (memq system-type '(windows-nt ms-dos))
                    (not (gnutls-available-p))))
       (proto (if no-ssl "http" "https")))
  (add-to-list 'package-archives (cons "melpa-stable" (concat proto "://stable.melpa.org/packages/")) t)
  (when (< emacs-major-version 24)
    (add-to-list 'package-archives '("gnu" . (concat proto "://elpa.gnu.org/packages/")))))

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

(require-package `magit)
(require-package 'company)
(require-package 'company-tern)
(require-package 'geben)
(require-package 'monokai-theme)
(require-package 'auto-complete)
(require-package 'color-theme-sanityinc-tomorrow)

(setq file-name-coding-system 'utf-8)
(color-theme-sanityinc-tomorrow-day)
;(color-theme-sanityinc-tomorrow-eighties)
;(load-theme 'monokai t)

;; magit settings

(global-set-key (kbd "C-x g") 'magit-status)

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

;; Выделяет скобки
(show-paren-mode t)
;; Выделять выражение в скобках
;; (setq show-paren-style 'expression

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

;; При сохранение: заменить табы пробелами, убрать лишние пробелы в конце строки, выровнять отступы

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(package-selected-packages
   (quote
    (magit xref-js2 projectile php-eldoc monokai-theme mmm-mode js2-refactor geben dirtree company-tern color-theme-solarized color-theme-sanityinc-tomorrow ag ac-php))))

(require `dired)
(defun custom-dired-sort ()
  ""
  (interactive)
  (dired-sort-other "-Al --si --time-style long-iso --group-directories-first"))

(define-key dired-mode-map (kbd "s") 'custom-dired-sort)

(defun dired-dotfiles-toggle ()
    "Show/hide dot-files"
    (interactive)
    (when (equal major-mode 'dired-mode)
      (if (or (not (boundp 'dired-dotfiles-show-p)) dired-dotfiles-show-p) ; if currently showing
	  (progn 
	    (set (make-local-variable 'dired-dotfiles-show-p) nil)
	    (message "h")
	    (dired-mark-files-regexp "^\\\.")
	    (dired-do-kill-lines))
	(progn (revert-buffer) ; otherwise just revert to re-show
	       (set (make-local-variable 'dired-dotfiles-show-p) t)))))

(define-key dired-mode-map (kbd ")") 'dired-dotfiles-toggle)
