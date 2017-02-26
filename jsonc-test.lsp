
(load "json-c.lsp")

(setq js (json-c:json_object_new_object))
(json-c:json_object_object_add js "type" (json-c:json_object_new_string "Request"))
(json-c:json_object_object_add js "method" (json-c:json_object_new_string "rpc_lcd_refresh_color"))
(json-c:json_object_object_add js "params" (json-c:json_object_new_string "0xff80"))
(json-c:json_object_object_add js "id" (json-c:json_object_new_string "0001"))
; (json-c:json_object_object_add js (string "type") (json-c:json_object_new_string (string "Request")))
; (json-c:json_object_object_add js (string "method") (json-c:json_object_new_string (string "rpc_lcd_refresh_color")))
; (json-c:json_object_object_add js (string "params") (json-c:json_object_new_string (string "0xff80")))
; (json-c:json_object_object_add js (string "id") (json-c:json_object_new_string (string "0001")))

(setq js2 (json-c:new-request "rpc_lcd_refresh_color" "{\"color\": \"0xf880\", \"test\": 123}" "0002"))

(setq js-str (json-c:json_object_to_json_string js))

(setq js-str2 (json-c:json_object_to_json_string js2))
