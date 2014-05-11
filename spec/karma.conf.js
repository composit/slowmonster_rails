module.exports = function(config){
  config.set({

    basePath : '../',

    files : [
      'vendor/assets/components/angular/angular.js',
      'vendor/assets/components/angular-route/angular-route.js',
      'vendor/assets/components/angular-mocks/angular-mocks.js',
      'vendor/assets/components/angular-resource/angular-resource.js',
      'app/assets/javascripts/angular/**/*.js.coffee',
      'spec/javascripts/**/*.js.coffee'
    ],

    autoWatch : true,

    frameworks: ['jasmine'],

    browsers : ['PhantomJS'],

    plugins : [
            'karma-chrome-launcher',
            'karma-firefox-launcher',
            'karma-phantomjs-launcher',
            'karma-jasmine',
            'karma-coffee-preprocessor'
            ],

    junitReporter : {
      outputFile: 'test_out/unit.xml',
      suite: 'unit'
    },

    preprocessors : {
      '**/*.js.coffee': ['coffee']
    }
  });
};
