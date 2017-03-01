(load "json2text.lsp")
(load "json-c.lsp")

(context 'jsonrpc)

;;(set 'librpcobjs "/usr/lib/librpc_objs.so")
(set 'librpcobjs "./librpc_objs.so")
;;(set 'librpcobjs "librpc_objs.so")

(set 'ERROR '((-32700 "RPC_PARSE_ERROR")
              (-32600 "RPC_INVALID")
              (-32601 "RPC_METHOD_NOT_FOUND")
              (-32603 "RPC_INVALID_PARAMS")
              (-32693 "RPC_INTERNAL_ERROR")))

(define (errcode2msg code)
  (let ((msg (lookup code ERROR)))
    (if msg
        msg
        "UNKNOWN ERROR")))

(define (c-symbol?)
  (let ((func (args 0)))
    (and (atom? func)
         (not (or (nil? func)
                  (= true func)
                  (number? func)
                  (string? func)
                  (symbol? func))))))

(define (check-string request)
  (if (list? request)
      (json2text request)
      request))

(define (new-request method params id)
  (let ((request '(("type" "Request"))))
    (push (list "method" method) request)
    (if params
        (push (list "params" params) request))
    (if id
        (push (list "id" id) request)
        request)))

(define (new-method-result result data error)
  (let ((ret nil))
    (if (= result "Success")
        (begin
          (setq ret '(("result" "Success")))
          (if data
              (push (list "data" data) ret)
              ret))
        (begin
          (setq ret '(("result" "Failure")))
          (if (list? error)
              (push (list "error" error) ret)
              ret)))))

(define (new-response call-result method-result call-error)
  (let ((response '(("type" "Result"))))
    (if (= call-result "Success")
        (begin
          (push (list "result" (list '("call" "Success"))) response)
          (push (list "ret" method-result) (lookup "result" response))
          response)
        (begin
          (push (list "result" (list '("call" "Failure"))) response)
          (if (list? call-error)
              (push (list "error" call-error) response))
          response))))

(define (new-error errcode msg data)
  (let ((err nil))
    (setq err (list (list "code" errcode)))
    (push (list "msg" msg) err)
    (if data
        (push (list "data" data) err)
        err)))

(define (request_have_id? req-expr)
  (let ((id (lookup "id" req-expr)))
    (if id
        id
        nil)))

(define (new-params-json-obj params)
  (cond
   ((string? params) (json-c:json_object_new_string params))
   ((number? params) (json-c:json_object_new_int params))
   ((= true params) (json-c:json_object_new_boolean 1))
   ((= "false" (string params)) (json-c:json_object_new_boolean 0))
   ((list? params) (json-c:json_tokener_parse (json2text params)))
   (true (json-c:json_object_new_object))))

(define (free-json-obj)
  (dolist (obj (args))
          (if obj
              (json-c:json_object_put obj))))

(define (rpc-error-handle)
  (let ((err (last-error)))
    (println (last err) " has occurred!")
    nil))

(error-event 'rpc-error-handle)

(define (single-rpc-process request-json-exp)
  (let ((method (lookup "method" request-json-exp))
        (params (lookup "params" request-json-exp))
        (id (lookup "id" request-json-exp)))
    (let ((rpc-method nil)
          (params-obj (new-params-json-obj params))
          (ret-method-obj nil)
          (ret-method-str nil)
          (response nil)
          (err nil))
      
      ;;(setq rpc-method (import librpcobjs method))
      (catch (import librpcobjs method) 'rpc-method)
      (if (c-symbol? rpc-method)
          (begin
            (setq ret-method-obj
                  (rpc-method params-obj))
            (setq ret-method-str
                  (json-c:json_object_to_json_string ret-method-obj))
            
            (setq response
                  (new-response "Success"
                                (json-parse ret-method-str)))
            (free-json-obj params-obj ret-method-obj)
            response)
          (begin
            (setq err (last-error))
            (println "err occurred: " err)
            (new-response "Failure" ,
                          (new-error -32601
                                     (errcode2msg -32601)
                                     request-json-exp)))))))

(define (rpc-process request-str)
  (let ((req-expr (json-parse request-str))
        (response '()))
    (if req-expr
        (begin
          (cond
           ((json2text:json-obj-expr? req-expr)
            (if (request_have_id? req-expr)
                (setq response (single-rpc-process req-expr))
                (single-rpc-process req-expr)))
           ((json2text:json-array-expr? req-expr)
            (dolist (req req-expr)
                    (if (request_have_id? req)
                        (push (single-rpc-process req-expr) response)
                        (single-rpc-process req-expr))))))
        (begin
          (setq response (new-response "Failure" ,
                                       (new-error -32700
                                                  errcode2msg(-32700))))))
    response))

(context MAIN)
