.( APP HERE)

: app-home
    s" %APP%/index.html" s" text/html;encoding=utf8" http-file-type ;
' app-home add-route-get /

: app-css
    s" %APP%/ui5.css" s" text/css" http-file-type ;
' app-css add-route-get /ui5.css

: app-favicon
    s" %APP%/favicon.ico" s" image/x-icon" http-file-type ;
' app-favicon add-route-get /favicon.ico

: app-400
    Null$ 0 s" HOME" #400 weberror ;
' app-400 add-route-get /400

: app-cpu
    s" /proc/cpuinfo" s" text/plain" http-file-type ;
' app-cpu add-route-get /cpu

: app-chunked
\ *G chunked encoding is very useful when sending content of unknown size
\ *P Note that 0 0 http-chunk denotes the end of the transfer. No more chunks are allowed afterwards.
    s" 200 OK" http-status
    s" Transfer-Encoding: chunked" http-header
    s" Content-Type: text/plain;encoding=utf8" http-header
    crlf
    s\" Hallo du\n" http-chunk
    s" Wie geht's?" http-chunk
    http-chunk-end ;
' app-chunked add-route-get /chunked

: app-manual
\ *G Manual reply
    s" 200 OK" http-status
    s" Content-Length: 5" http-header
    s" Content-Type: text/plain;encoding=utf8" http-header
    crlf
    wait-socket-empty
    ." HALLO"
    crlf
    crlf
    wait-socket-empty ;
' app-manual add-route-get /man

WebSocketServerDev: mywss
255 constant /wsinp
/wsinp buffer: wsinp

0 value quitnow

: cya -1 to quitnow ;

: websocket-quit ( sid -- )
\ *G Empty the return stack, store 0 in *\fo{SOURCE-ID}, and enter
\ ** interpretation state. *\fo{TN_QUIT} repeatedly *\fo{ACCEPT}s a line of
\ ** input and *\fo{INTERPRET}s it, with a prompt if interpreting
\ ** and *\fo{ECHOING} on. Note that any task that uses *\fo{TN_QUIT} must
\ ** initialise *\fo{'TIB}, *\fo{BASE}, *\fo{IP-HANDLE}, and *\fo{OP-HANDLE}. Note that
\ ** *\fo{TN_QUIT} sets the stack depth to one on exit.
    0 to quitnow
    begin
        cr query                        \ get user input
        ['] interpret catch ?dup 0= if  \   interpret line
            state @ 0= if               \   if interpreting
                ."  ok"  depth ?dup     \     prompt user
                if  ." -" .  then
            then
        else
            .throw  [compile] [         \    display error, clean up
            cr source type              \    display input line
            cr >in @ 1- spaces ." ^"    \    display pointer to error
        then
        \ SVdone?                         \ Until can be closed
        quitnow
    until ;                             \ do next line

: app-ws
\ *G Websocket upgrade
    s" 101 Switching Protocols" http-status
    s" Upgrade: websocket" http-header
    s" Connection: Upgrade" http-header
    SVIdata Get-Sec-WebSocket-Accept s" Sec-WebSocket-Accept" http-header-value
    s" Sec-WebSocket-Protocol: ui5" http-header
    crlf
    wait-socket-empty

    mysid gen-handle @ mywss open-gio \ open
    [io mywss setio
        (.cold)
        cr ." Ein herzliches Hallo von GenIO :D"
        ['] websocket-quit catch >r
        s0 @ sp! r>
        cr ." MCP: End Of Line -"
    io]
    wait-socket-empty
    ;

' app-ws add-route-get /ws

\ TODO: replace by wildcard. Hint: Wildcard required passing of path, use QV?
: app-img1 s" %APP%/images/ui5.svg"      http-file ; ' app-img1 add-route-get /images/ui5.svg
: app-img2 s" %APP%/images/help.svg"     http-file ; ' app-img2 add-route-get /images/help.svg
: app-img3 s" %APP%/images/terminal.svg" http-file ; ' app-img3 add-route-get /images/terminal.svg

\ TODO: implement serve-static-dir
: app-js1 s" %APP%/js/main.js"           s" application/javascript" http-file-type ; ' app-js1 add-route-get /js/main.js
: app-js2 s" %APP%/js/vfx-navigation.js" s" application/javascript" http-file-type ; ' app-js2 add-route-get /js/vfx-navigation.js
: app-js3 s" %APP%/js/vfx-connector.js"  s" application/javascript" http-file-type ; ' app-js3 add-route-get /js/vfx-connector.js
: app-js4 s" %APP%/js/vfx-terminal.js"   s" application/javascript" http-file-type ; ' app-js4 add-route-get /js/vfx-terminal.js
: app-js5 s" %APP%/js/night-theme.js"    s" application/javascript" http-file-type ; ' app-js5 add-route-get /js/night-theme.js
