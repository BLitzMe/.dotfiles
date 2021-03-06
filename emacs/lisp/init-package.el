;;; package --- init-package
;;; Commentary:
;;; copy from: https://github.com/purcell/emacs.d/blob/master/lisp/init-elpa.el

;;; Code:

(require 'package)

;;; Standard package repositories
(let ((repos
       (list
        '("gnu" . "http://elpa.gnu.org/packages/")
        '("melpa-stable" . "https://stable.melpa.org/packages/")
        '("melpa" . "https://melpa.org/packages/")
        ;;'("elpy" . "https://jorgenschaefer.github.io/packages/")
        ;;'("marmalade" . "http://marmalade-repo.org/packages/")
        ;;'("org" . "http://orgmode.org/elpa/")
        )))
  (setq package-archives ())
  (dolist (item repos)
    (add-to-list 'package-archives item))
  (message "Package archives: %s" package-archives))


;;; On-demand installation of packages

(defun require-package (package &optional min-version no-refresh)
  "Install given PACKAGE, optionally requiring MIN-VERSION.
If NO-REFRESH is non-nil, the available package lists will not be
re-downloaded in order to locate PACKAGE."
  (if (package-installed-p package min-version)
      t
    (if (or (assoc package package-archive-contents) no-refresh)
        (if (boundp 'package-selected-packages)
            ;; Record this as a package the user installed explicitly
            (package-install package nil)
          (package-install package))
      (progn
        (package-refresh-contents)
        (require-package package min-version t)))))


(defun maybe-require-package (package &optional min-version no-refresh)
  "Try to install PACKAGE, and return non-nil if successful.
In the event of failure, return nil and print a warning message.
Optionally require MIN-VERSION.  If NO-REFRESH is non-nil, the
available package lists will not be re-downloaded in order to
locate PACKAGE."
  (condition-case err
      (require-package package min-version no-refresh)
    (error
     (message "Couldn't install package `%s': %S" package err)
     nil)))


(defmacro maybe-require-package-init (package init &optional min-version no-refresh)
  "Not working yet.
Execute init fun after the require successfully."
  `(condition-case err
      (progn
        (require-package package min-version no-refresh)
        ,init)
    (error
     (message "Couldn't install package `%s': %S" package err)
     nil)))


;;; Fire up package.el
(setq package-enable-at-startup nil)
(package-initialize)


(provide 'init-package)
;;; init-package   ends here
