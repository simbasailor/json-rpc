#!/usr/bin/newlisp

(load "jsonrpc_server.lsp")
(load "jsonrpc_event_server.lsp")

(new jsonrpc-server 'rpc-server)
(new jsonrpc-event-server 'event-server)

(set 'rpc-serv-pid (fork (rpc-server:server-start 9098)))
(println "rpc server start at port 9098. pid: " rpc-serv-pid)

(set 'event-serv-pid (fork (event-server:server-start 9099)))
(println "event server start at port 9099. pid: " event-serv-pid)

(exit)
