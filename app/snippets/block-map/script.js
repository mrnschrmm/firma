
class BlockMap extends window.HTMLDivElement {
  constructor (self) {
    self = super(self)
    self.resolveElements()
    return self
  }

  resolveElements () {
  }

  connectedCallback () {
    console.log('### BLOCK-MAP - SCRIPT.JS ###')
  }
}

window.customElements.define('block-map', BlockMap, { extends: 'div' })
