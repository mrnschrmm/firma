import View from './components/View.vue'

panel.plugin('firma/options', {
  views: {
    example: {
      component: View,
      icon: 'preview',
      label: 'Options'
    }
  }
})
