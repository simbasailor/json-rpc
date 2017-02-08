(context 'jsonrpc)

(set 'ERROR '((-32700 "RPC_PARSE_ERROR")
              (-32600 "RPC_INVALID")
              (-32601 "RPC_METHOD_NOT_FOUND")
              (-32603 "RPC_INVALID_PARAMS")
              (-32693 "RPC_INTERNAL_ERROR")))

(define (new-response call-result method-result)
  (let ((response '(("type" "Result"))))))

(define (new-error ))

(define (single-rpc-process request-json-exp)
  (let ((method (lookup "method" request-json-exp))
        (params (lookup "params" request-json-exp)))
    (if (nil? method)
        '("type" ))))



(context MAIN)
