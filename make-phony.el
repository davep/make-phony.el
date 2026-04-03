;;; make-phony.el --- Make a Makefile target PHONY -*- lexical-binding: t -*-
;; Copyright 2018-2019 by Dave Pearson <davep@davep.org>

;; Author: Dave Pearson <davep@davep.org>
;; Version: 1.2
;; Keywords: convenience
;; URL: https://github.com/davep/make-phony.el
;; Package-Requires: ((emacs "24"))

;; This program is free software: you can redistribute it and/or modify it
;; under the terms of the GNU General Public License as published by the
;; Free Software Foundation, either version 3 of the License, or (at your
;; option) any later version.
;;
;; This program is distributed in the hope that it will be useful, but
;; WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General
;; Public License for more details.
;;
;; You should have received a copy of the GNU General Public License along
;; with this program. If not, see <http://www.gnu.org/licenses/>.

;;; Commentary:
;;
;; make-phony.el provides a simple command that can be used to make a target
;; in a Makefile into a PHONY target.

;;; Code:

(defun make-phony--already (phony)
  "Return non-nil if PHONY is already on the previous line."
  (save-excursion
    (forward-line -1)
    (goto-char (line-beginning-position))
    (looking-at phony)))

;;;###autoload
(defun make-phony ()
  "Make the current Makefile target PHONY."
  (interactive)
  (if (derived-mode-p 'makefile-gmake-mode 'makefile-bsdmake-mode)
      (save-excursion
        (goto-char (line-beginning-position))
        (if (looking-at (rx bol (group (+ (not (any ":")))) ":"))
            (let ((phony (format ".PHONY: %s\n" (match-string 1))))
              (unless (make-phony--already phony)
                (insert phony)))
          (error "Can't see a target that should be .PHONY")))
    (error "This function is only designed for Makefiles")))

(provide 'make-phony)

;;; make-phony.el ends here
