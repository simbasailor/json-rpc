;; client connects to sender

(load "json2text.lsp")
(load "jsonrpc.lsp")

(constant 'max-bytes 4096)

;; configure message-from-server ...

(define (send-request host-exp request)
  (let ((socket (apply 'net-connect host-exp)))
    (if (not socket)
        (print "could not connect, is the server started?\n" (net-error))
        (let ((request-str (jsonrpc:check-string request)) (response-str nil))
          (net-send socket request-str)
          (if (not (net-select socket "r" 5000000))
              (begin
                (net-close socket)
                (print "timeout" (net-error)))
              (begin
                (net-receive socket response-str max-bytes)
                (net-close socket)
                (if (not response-str)
                    (print "receive response fail" (net-error))
                    response-str)))))))


