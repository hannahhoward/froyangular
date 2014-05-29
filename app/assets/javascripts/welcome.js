'use strict';

var froyoApp = angular.module('froyoapp', ['ngResource']).config(
  ['$httpProvider', function($httpProvider) {
  var authToken = angular.element("meta[name=\"csrf-token\"]").attr("content");
  var defaults = $httpProvider.defaults.headers;
  defaults.common["X-CSRF-TOKEN"] = authToken;
  defaults.patch = defaults.patch || {};
  defaults.patch['Content-Type'] = 'application/json';
}]);

froyoApp.controller('YogurtCtrl', ['Yogurt', '$scope',
  function(Yogurt, $scope) {
    $scope.yogurts = []

    $scope.newYogurt = new Yogurt({topping: "", quantity: "", flavor: ""});

    Yogurt.query(function(yogurts) {
      yogurts.forEach(function(yogurt) {
        angular.extend(yogurt, {
          editing: false,
          details: false
        });
      });
      $scope.yogurts = yogurts;
    });

    $scope.details = function(yogurt) {
      yogurt.details = true;
      yogurt.editing = false;
    };

    $scope.editing = function (yogurt) {
      yogurt.editing = true;
      yogurt.details = false;
    };

    $scope.update = function (yogurt) {
      yogurt.$update(function(response) {
        yogurt.editing = false;
      });
    };

    $scope.create = function() {
      $scope.newYogurt.$save(function(yogurt) {
        angular.extend(yogurt, {
          editing: false,
          details: false
        });
        $scope.yogurts.push(yogurt);
        $scope.newYogurt = new Yogurt({topping: "", quantity: "", flavor: ""});
      });
    }

    $scope.price = function(yogurt) {
      return (yogurt.quantity * 0.15);
    }
    $scope.delete = function(yogurt) {
      yogurt.$delete(function() {
        position = $scope.yogurts.indexOf(yogurt);
        $scope.yogurts.splice(position, 1);
      });
    }
  }]);

froyoApp.factory('Yogurt', ['$resource', function($resource) {
  return $resource('/yogurts/:id',
  {id: '@id'},
  {update: {method: 'PATCH'}});
}]);