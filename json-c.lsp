

(setq json_type:null 0)
(setq json_type:boolean 1)
(setq json_type:double 2)
(setq json_type:int 3)
(setq json_type:object 4)
(setq json_type:array 6)
(setq json_type:string 7)


(context 'json-c)

(cond
 ((= ostype "Linux")
  ;;(define libjson "/usr/lib/libjson-c.so")
  (set 'libjson "/usr/lib/x86_64-linux-gnu/libjson-c.so"))
 ((find ostype '("Windows" "Cygwin"))
  (set 'libjson "libjson-c.dll")))

(import libjson "json_tokener_parse" "void*" "char*")
(import libjson "json_tokener_free" "void" "void*")
(import libjson "json_object_put" "int" "void*")
(import libjson "json_object_get_type" "int" "void*")
(import libjson "json_object_is_type" "int" "void*" "int")
(import libjson "json_object_to_json_string" "char*" "void*")
(import libjson "json_object_new_object" "void*" "void")
(import libjson "json_object_new_boolean" "void*" "int")
(import libjson "json_object_get_boolean" "int" "void*")
(import libjson "json_object_new_int" "void*" "int")
(import libjson "json_object_get_int" "int" "void*")
(import libjson "json_object_new_double" "void*" "double")
(import libjson "json_object_get_double" "double" "void*")
(import libjson "json_object_new_string" "void*" "char*")
(import libjson "json_object_new_string_len" "void*" "char*" "int")
(import libjson "json_object_get_string" "char*" "void*")
(import libjson "json_object_get_string_len" "int" "void*")
(import libjson "json_object_object_length" "int" "void*")

(import libjson "json_object_new_array" "void*" "void")
(import libjson "json_object_array_length" "int" "void*")
(import libjson "json_object_array_add" "int" "void*" "void*")
(import libjson "json_object_array_put_idx" "int" "void*" "int" "void*")

(import libjson "json_object_object_add" "void" "void*" "char*" "void*")
(import libjson "json_object_object_get" "void*" "void*" "char*")
(import libjson "json_object_object_del" "void" "void*" "char*")

(define (new-request)
  (let ((req (json_object_new_object))
        (method (args 0))
        (params (args 1))
        (id (args 2)))
    (json_object_object_add req "type" (json_object_new_string "Request"))
    (json_object_object_add req "method" (json_object_new_string method))
    (json_object_object_add req "params" (json_tokener_parse params))
    (cond
     ((number? id) (json_object_object_add req "id" (json_object_new_int id)))
     ((string? id) (json_object_object_add req "id" (json_object_new_string id)))
     (true req))
    req))

(context MAIN)
