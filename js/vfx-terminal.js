/* vfx-terminal: outer custom element for a websocket terminal */

const template = document.createElement('template');
template.innerHTML = `
    <style>
        :host {
            display: block;
            font-family: monospace;
            font-size: 14px;
        }
        .terminalWrapper {
            border: 5px dashed var( --border-color, #A00 );
        }
        .terminalWrapper .input {
            color: var( --input-color, #FFF );
        }
        input[name="source"] {
            /* todo: take styles from global stylsheet, access custom properties? */
            font-family: monospace;
            font-size: 16px;

            color: var( --input-color, #FFF );
            background-color: var( --input-background, transparent );
            border: none;
            display: block;
            width: 100%;
        }
    </style>
    <div class="terminalWrapper">
        VFX Terminal
        <button>Connect</button>
        <input name="source" type="text" autofocus/>
    </div>
`;

class VfxTerminal extends HTMLElement {
    constructor() {
        super();

        const shadow = this.attachShadow({ mode: 'open' });
        shadow.appendChild( template.content.cloneNode( true ) );

        shadow.querySelector("button").addEventListener("click", evt => {
            shadow.querySelector("button").remove();
            /* TODO: use global events */
            window.wsc();
        });
        //shadow.querySelector("button").remove()

        this.textContainer = shadow.querySelector("div.terminalWrapper");
        this.source = shadow.querySelector("input[name='source']");

        this.source.addEventListener("keyup", evt => {
            if( evt.keyCode == 13 ) {
                evt.preventDefault();
                var text = this.source.value;
                this.write( `<span class="input">${text}</span>` );
                text += "\r\n";
                /* todo: use global events */
                window.ws.send( text );
                this.source.value = "";
            }
        });
    }
    write( text ) {
        text = text.replace( /\r\n/g, "\n" ).replace("\n", "<br/>");
        this.source.insertAdjacentHTML('beforebegin', text );

        if( !this.writeScrollTimout )
            this.writeScrollTimout = window.setTimeout( () => {
                this.source.scrollIntoView();
                this.writeScrollTimout = null;
            }, 100);
    }
}

customElements.define( 'vfx-terminal', VfxTerminal );
