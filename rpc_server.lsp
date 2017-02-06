; sender listents

(constant 'max-bytes 4096)

(if (not (set 'listen (net-listen 8989)))
    (print (net-err)))

(while (not (net-error))
       (set 'connection (net-accept listen)) ;blocking here

       (net-receive connection message-from-client max-bytes)
       ;; process message from client
       ;; configure message to client
       (net-send connection message-to-client)
       (close connection))
