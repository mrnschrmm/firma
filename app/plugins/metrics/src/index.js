import View from './components/View.vue'

panel.plugin('firma/metrics', {
  views: {
    example: {
      component: View,
      icon: 'preview',
      label: 'Metrics'
    }
  }
})
