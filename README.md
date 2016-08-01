# emacs-rem
An event handling system for Emacs Lisp.

This project is on initial stage(alpha version).

## Example

(e:event 'copy)   ;; new event type
(defvar hnd (e:register 'copy (lambda ()              ;; adding handler
				(message "got fired."))))
(e:emit 'copy)                             ;; emit event
(e:deregister hnd 'copy)                  ;; unregistering handler
  

                              
                              
