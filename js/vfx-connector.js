/* vfx-connector: websocket connector to vfx-host */

const url = (location.protocol == "https:"?"wss":"ws") + "://" +location.host + location.pathname + "ws";

function onOpen() {
    document.body.classList.add("vfx-connected");
}

function onClose() {
    document.body.classList.remove("vfx-connected");
}

async function onMessage( { data } ) {
    if( data instanceof Blob ) {
        var b = new Uint8Array( await new Response(data).arrayBuffer() );
        console.log( "Unknown Blob message:", b );
    }
    else {
        //var json = JSON.parse( data );
        var vfxTerminal = document.querySelector("vfx-terminal");
        if( !vfxTerminal )
            return console.log( "Text-Message:", data );
        vfxTerminal.write( data );
    }
}

/* reconnect on open-erro / close */
var ws = null;
var connected = false;
function connect() {
    try {
        ws = new WebSocket( url, ["ui5"] );
    } catch( err ) {
        console.log( "Websocket open-error, attempting reconnect...", err );
        return window.setTimeout( connect, 5000 );
    }
    ws.onopen = () => {
        connected = true;
        onOpen();
        window.ws = ws;
    };
    ws.onmessage = onMessage;
    ws.onclose = function() {
        console.log( "Websocket closed, attempting reconnect..." );
        if( connected ) {
            onClose();
            connected = false;
        }
        window.setTimeout( connect, 500 );
    }
}

//connect();

window.wsc = connect;
