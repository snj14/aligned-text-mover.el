;;; aligned-text-mover.el --- Move caret top/bottom of aligned text

;; Author: snj14
;; Keywords: command move caret align
;; Version: 2014.11.11

;; # overview
;;
;;                                 move caret
;;                          v----- from here
;;  text   (text text text) text
;;  text aaa text text text text
;;  text text _____________ text
;;  aaa bbb ccc ddd eee fff text
;;                          ^---- to here
;;
;; # setting
;;
;;  (global-set-key (kbd "M-n") 'atm/goto-bottom)
;;  (global-set-key (kbd "M-p") 'atm/goto-top)


(defun atm/get-position (direction)
    (let ((syntax (concat "\\s" (string (char-syntax (char-after)))))
          forward-line-res)
      (save-excursion
        (loop with pos      = (point)
              with col      = (current-column)
              with forward  = (looking-at syntax)
              with backward = (looking-back syntax (line-beginning-position))
              do (setq forward-line-res (forward-line (if direction 1 -1)))
              do (move-to-column col)
              while (not (eq forward-line-res -1))
              while (= col (current-column))
              while (equal backward (looking-back syntax (line-beginning-position)))
              while (equal forward  (looking-at syntax))
              do (setq pos (point)
                       backward (looking-back syntax (line-beginning-position))
                       forward  (looking-at syntax))
              finally
              return pos))))

;;;###autoload
(defun atm/goto-top ()
  (interactive)
  (when (equal real-last-command this-command)
    (let ((col (current-column)))
      (forward-line -1)
      (move-to-column col)))
  (goto-char (atm/get-position nil)))

;;;###autoload
(defun atm/goto-bottom ()
  (interactive)
  (when (equal real-last-command this-command)
    (let ((col (current-column)))
      (forward-line)
      (move-to-column col)))
  (goto-char (atm/get-position t)))

(provide 'aligned-text-mover)
;;; aligned-text-mover.el ends here
