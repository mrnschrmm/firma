import View from './components/View.vue'

panel.plugin('firma/options', {
  views: {
    options: {
      component: View,
      icon: 'cog',
      label: 'Optionen'
    }
  }
})
