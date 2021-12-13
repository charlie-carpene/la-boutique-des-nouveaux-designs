module.exports = {
  plugins: [
    require('postcss-import'),
    require('postcss-flexbugs-fixes'),
    require('postcss-preset-env')({
      autoprefixer: {
        flexbox: 'no-2009'
      },
      stage: 3
    }),
    require('@fullhuman/postcss-purgecss')({
      content: [
        './**/*.html.erb',
        './app/helpers/**/*.rb',
        './app/javascript/**/*.js'
      ],
      defaultExtractor: content => content.match(/[\w-/.:]+(?<!:)/g) || [],
      whitelistPatterns: [],
      whitelistPatternsChildren: [/uppy/],
    })  
  ]
}
