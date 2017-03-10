
(context 'log)

(if (= ostype "Linux")
    (setq libc "/lib/i386-linux-gnu/libc-2.19.so"))

(setq LOG_EMERG       0)
(setq LOG_ALERT       1)
(setq LOG_CRIT        2)
(setq LOG_ERR         3)
(setq LOG_WARNING     4)
(setq LOG_NOTICE      5)
(setq LOG_INFO        6)
(setq LOG_DEBUG       7)

(if libc
    (catch (import libc "syslog") 'syslog))

(define (err)
  (let ((msg (map string (args)))))
  (and syslog
       (apply syslog (string msg)))
  )

(context MAIN)
