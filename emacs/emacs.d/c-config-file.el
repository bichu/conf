; -----------------------------------------------------------------------------
; Option for C/C++ files
; -----------------------------------------------------------------------------

; Comment boxing

(defun insert-header-guard ()
 (interactive)
 (save-excursion
   (when (buffer-file-name)
       (let*
           ((name (file-name-nondirectory buffer-file-name))
            (macro (replace-regexp-in-string
                    "\\." "_"
                    (replace-regexp-in-string
                     "-" "_"
                     (upcase name)))))
         (goto-char (point-min))
        (insert "#ifndef " macro "_\n")
         (insert "# define " macro "_\n\n")
         (goto-char (point-max))
         (insert "\n#endif /* !" macro " */\n")))))

(defun insert-header-inclusion ()
 (interactive)
 (when (buffer-file-name)
   (let
      ((name
         (replace-regexp-in-string ".c$" ".h"
           (replace-regexp-in-string ".cc$" ".hh"
            (file-name-nondirectory buffer-file-name)))))
     (insert "#include \"" name "\"\n\n"))))

; Auto insert C/C++ header guard
(add-hook 'find-file-hooks
	  (lambda ()
	    (when (and (memq major-mode '(c-mode c++-mode)) (equal (point-min) (point-max)) (string-match ".*\\.hh?" (buffer-file-name)))
	      (insert-header-guard)
	      (goto-line 3)
	      (insert "\n"))))

(add-hook 'find-file-hooks
	  (lambda ()
	    (when (and (memq major-mode '(c-mode c++-mode)) (equal (point-min) (point-max)) (string-match ".*\\.cc?" (buffer-file-name)))
	      (insert-header-inclusion))))
