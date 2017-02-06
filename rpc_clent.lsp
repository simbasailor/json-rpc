;; client connects to sender

(constant 'max-bytes 4096)


(unless (set 'connection (net-connect "127.0.0.1" 8989))
        (println (net-error))
        (exit))

;; configure message to server ...
(net-send connection message-to-server)
(net-receive connection message-from-server max-bytes)
;; configure message-from-server ...
