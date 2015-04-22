'use strict'

angular.module('slowMonster.directives')
  .directive 'rickshawChart', ['$compile', ($compile) ->
    return {
      restrict: 'EA',
      scope: {
        options: '=rickshawOptions',
        series: '=rickshawSeries',
        features: '=rickshawFeatures'
      },
      # replace: true,
      link: (scope, element, attrs) ->
        getSettings = (el) ->
          settings = angular.copy(scope.options)
          settings.element = el
          settings.series = scope.series
          return settings

        graph = null

        update = () ->
          mainEl = angular.element(element)
          mainEl.append(graphEl)
          mainEl.empty()
          graphEl = $compile('<div></div>')(scope)
          mainEl.append(graphEl)
          settings = getSettings(graphEl[0])
          graph = new Rickshaw.Graph(settings)

          if (scope.features && scope.features.hover)
            hoverConfig = {graph: graph}
            hoverConfig.xFormatter = scope.features.hover.xFormatter
            hoverConfig.yFormatter = scope.features.hover.yFormatter
            hoverDetail = new Rickshaw.Graph.HoverDetail(hoverConfig)

          if (scope.features && scope.features.palette)
            palette = new Rickshaw.Color.Palette({scheme: scope.features.palette})
            for series in settings.series
              series.color = palette.color()

          graph.render()

          if (scope.features && scope.features.xAxis)
            xAxisConfig = {graph: graph}
            if (scope.features.xAxis.timeUnit)
              time = new Rickshaw.Fixtures.Time()
              xAxisConfig.timeUnit = time.unit(scope.features.xAxis.timeUnit)

            xAxis = new Rickshaw.Graph.Axis.Time(xAxisConfig)
            xAxis.render()

          if (scope.features && scope.features.yAxis)
            yAxisConfig = {graph: graph}
            if (scope.features.yAxis.tickFormat)
              yAxisConfig.tickFormat = Rickshaw.Fixtures.Number[scope.features.yAxis.tickFormat]

            yAxis = new Rickshaw.Graph.Axis.Y(yAxisConfig)
            yAxis.render()

          if (scope.features && scope.features.legend)
            legendEl = $compile('<div></div>')(scope)
            mainEl.append(legendEl)

            legend = new Rickshaw.Graph.Legend({
              graph: graph,
              element: legendEl[0]
            })
            if (scope.features.legend.toggle)
              shelving = new Rickshaw.Graph.Behavior.Series.Toggle({
                graph: graph,
                legend: legend
              })
            if (scope.features.legend.highlight)
              highlighter = new Rickshaw.Graph.Behavior.Series.Highlight({
                graph: graph,
                legend: legend
              })

        scope.$watch 'options', (newValue, oldValue) ->
          if (!angular.equals(newValue, oldValue))
            update()

        scope.$watch 'series', (newValue, oldValue) ->
          if (!angular.equals(newValue, oldValue))
            update()

        scope.$watch 'features', (newValue, oldValue) ->
          if (!angular.equals(newValue, oldValue))
            update()

        update()

      controller: ($scope, $element, $attrs) ->
    }
  ]
