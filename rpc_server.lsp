; sender listents

(load "json2text.lsp")
(load "jsonrpc.lsp")

(constant 'max-bytes 4096)

(define (rpc-server-accept listen)
  (while online
         (let ((connect (net-accept listen)) (request-str nil) (response nil))
           (net-receive connect request-str max-bytes)
           (print "get request: " request-str)
           (setq response (new-response "Success" '("result" "Success")))
           (net-send connect (check-string response))
           (net-close connect))))

(define (rpc-server host-port)
  (let ((socket (net-listen host-port)))
    (if (not socket)
        (print "Listen failed\n" (net-error))
      (begin
        (set 'online true)
        (print "Server started\n")
        (rpc-server-accept socket)))))

