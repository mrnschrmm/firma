var $ = window.jQuery

class BlockMap extends window.HTMLDivElement {
  constructor (...args) {
    const self = super(...args)
    self.init()
    return self
  }

  init () {
  }

  resolveElements () {
  }

  connectedCallback () {
    console.log('### BLOCK-MAP - SCRIPT.JS ###')
  }
}

window.customElements.define('block-map', BlockMap, { extends: 'div' })
