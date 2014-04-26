module.exports = function(config){
  config.set({

    basePath : '../',

    files : [
      'vendor/assets/components/angular/angular.js',
      'vendor/assets/components/angular-route/angular-route.js',
      'vendor/assets/components/angular-mocks/angular-mocks.js',
      'app/assets/javascripts/angular/**/*.js',
      'spec/javascripts/**/*.js'
    ],

    autoWatch : true,

    frameworks: ['jasmine'],

    browsers : ['PhantomJS'],

    plugins : [
            'karma-chrome-launcher',
            'karma-firefox-launcher',
            'karma-phantomjs-launcher',
            'karma-jasmine'
            ],

    junitReporter : {
      outputFile: 'test_out/unit.xml',
      suite: 'unit'
    }

  });
};
