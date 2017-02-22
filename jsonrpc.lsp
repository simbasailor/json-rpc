;;(context 'jsonrpc)

(set 'ERROR '((-32700 "RPC_PARSE_ERROR")
              (-32600 "RPC_INVALID")
              (-32601 "RPC_METHOD_NOT_FOUND")
              (-32603 "RPC_INVALID_PARAMS")
              (-32693 "RPC_INTERNAL_ERROR")))

(define (check-string request)
  (if (list? request)
      (json2text request)
      request))

(define (new-method-result )
  )

(define (new-response call-result method-result call-error)
  (let ((response '(("type" "Result"))))
    (if (= call-result "Success")
        (begin
          (push '("call" "Success") response)
          (push (list "ret" method-result) response))
        (begin
          (push '("call" "Failure") response)
          (if (list? call-error)
              (push (list "error" call-error) response))
          response))))

(define (new-error err-no msg data)
  )

(define (single-rpc-process request-json-exp)
  (let ((method (lookup "method" request-json-exp))
        (params (lookup "params" request-json-exp)))
    (if (nil? method)
        )))



;;(context MAIN)
