; sender listents

(load "json2text.lsp")
(load "jsonrpc.lsp")

(constant 'max-bytes 4096)

(setq rpc-listen-socket nil)

(define (rpc-server-accept listen)
  (while online
         (let ((connect (net-accept listen))
               (request-str nil)
               (request-exp nil)
               (response nil)
               (rlen 0))
           (setq rlen (net-receive connect request-str max-bytes))
           (println "get request: " request-str ", size:" rlen)
           
           (setq response (jsonrpc:rpc-process request-str))
           (if (and (list? response)
                    (not (empty? response)))
               (begin
                 (println "return response: " (jsonrpc:check-string response))
                 (net-send connect (jsonrpc:check-string response))))
           (net-close connect))))

(define (rpc-server host-port)
  (let ((socket (net-listen host-port)))
    (if (not socket)
        (print "Listen failed\n" (net-error))
      (begin
        (set 'online true)
        (setq rpc-listen-socket socket)
        (print "Server started\n")
        (rpc-server-accept socket)
        (net-close socket)))))

