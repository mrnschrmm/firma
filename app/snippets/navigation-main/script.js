class NavigationMain extends window.HTMLDivElement {
  constructor (self) {
    self = super(self)
    self.resolveElements()
    return self
  }

  resolveElements () {
  }

  connectedCallback () {
    console.log('### NAVIGATION-MAIN - SCRIPT.JS ###')
  }
}

window.customElements.define('navigation-main', NavigationMain, { extends: 'div' })
