; sender listents

(load "json2text.lsp")
(load "jsonrpc.lsp")

(context 'jsonrpc-event-server)

(constant 'max-bytes 4096)

(setq listen-socket nil)

(define (accept-connect-process connect)
  (catch (let ((request-str nil)
               (request-exp nil)
               (response nil)
               (rlen 0))
           (setq rlen (net-receive connect request-str max-bytes))
           (println "get request: " request-str ", size:" rlen)
    
           (setq response (jsonrpc:rpc-process request-str))
           (if (and (list? response)
                    (not (empty? response)))
               (begin
                 (println "return response: "
                          (jsonrpc:check-string response))
                 (net-send connect (jsonrpc:check-string response))))
           (net-close connect))))

(define (server-accept listen)
  (while online
         (catch (net-accept listen) 'connect)
         (if connect
             (accept-connect-process connect))))

(define (server-start host-port)
  (let ((socket (net-listen host-port)))
    (if (not socket)
        (println "Listen failed\n" (net-error))
      (begin
        (set 'online true)
        (setq listen-socket socket)
        (println "Event Server started\n")
        (server-accept socket)
        (net-close socket)))))

(context MAIN)
