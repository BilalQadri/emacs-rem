  ;;; -*- lexical-binding: t -*-

(setq lexical-binding t)
  
(defmacro cassoc (key value)
  "combining 'cdr and 'assoc"
  `(cdr (assoc ,key ,value)))



(defvar *e:events* '())   ;;  events with handlers ((copy 'hnd0 'hnd1 )) 



(defun  e:event (e)
  "new event"
  (if (not (e:event-exists e))
      (e:add-event e)))


(defun e:register (event func)
  "register(attach) handler to the event."
  
  (let ((hnd (e:unique-symbol)))
    
    (e:add-handler hnd event)
    (e:attach-func hnd func)
    
    hnd))

(defun e:emit (e)
  "(emitting)calling all handlers"
  (e:call-handlers (cassoc e *e:events*)))


(defun e:deregister (hnd event)
  "removing and uninterning handler"
  
  (cond ((not (e:event-exists event))
	 (error "Event type '%S does not exist." event))
	(t 
	 (let ((handler (e:find-handler hnd event)))
	   (cond ((equal handler nil)
		  (display-warning 'ignore  "Handler does not exist." :warning))
		 (t (delete handler (e:all-handlers event))
		    (unintern hnd)))))))


;;;; helper functions


(defun e:unique-symbol ()
  "creating unique symbol."
  (intern (symbol-name (cl-gensym "hnd"))))

(defun e:add-handler (hnd e)
  "add handler to the event"
  
  (if (not (e:event-exists e))
      (error "Event type '%S does not exist." e)
  (push hnd (cassoc e *e:events*))))



(defun e:attach-func (hnd func)
  "atttach function to handler"
  (put hnd 'func func))
  


      
(defun  e:find-handler (hnd e)
  "find handler of the event"
  (car (member hnd (e:all-handlers e))))

(defun e:all-handlers (e)
  "all handlers"
  (cassoc e  *e:events*))


(defun e:call-handlers (hnds)
  "call all handlers of the event"

  (let ((hnd (car hnds)))
    (cond ((not (equal hnd nil))
	   (funcall (get hnd 'func))
	   (e:call-handlers (cdr hnds))))))



(defun e:add-event (e)
  "adding event"
  (push (cons e '()) *e:events*))


(defun e:event-exists (e)
  "check event existense"
  (if (assoc e *e:events*)
      1
    nil))










