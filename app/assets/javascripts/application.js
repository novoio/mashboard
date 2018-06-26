// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require angular/angular
//= require angular-route/angular-route
//= require angular-rails-templates
//= require ngInfiniteScroll
//= require angular-resource
//= require flat-ui
//= require bootstrap-sprockets
//= require_tree .

var mashboard = angular.module('mashboard', ['ngRoute', 'ngResource']);

mashboard.constant('chunkSize', 10);
mashboard.controller('WidgetController',
    function($scope, chunkSize, $http, $location, Widget, SelectedFilters) {
        $scope.widget = null;
        // $scope.stockList = [];
        // var currentIndex = 0;
        $scope.busy = false;
        var page = 1;
        // var todayDate = new Date();
        var url_base = $location.protocol() + "://" + $location.host() + ":" + $location.port() + "/widgets/";

        $scope.widgetId = 0;

        $scope.SelectedFilters = SelectedFilters;

        $scope.filters = [];
        $scope.appliedFilters = [];

        $scope.gitFilterList = function(widgetId)
        {
          $scope.isFilterLoading = true;
          $http.get("/filters?widgetid=" + widgetId)
          .success(function(data){
            if (data.success) {
              $scope.filters = data.success.filters;
              $scope.filters.forEach(function(filter){
                if (filter.is_applied)
                  // $scope.SelectedFilters.push(filter.filter);
                $scope.appliedFilters.push(filter.filter);
              });
              $scope.isFilterLoading = false;
              // $scope.loadMoreRecords(widgetId);
              $scope.loadMoreRecords(widgetId);
            }
          });
        };

        $scope.init = function(widgetId, widget_type) {
          $scope.widgetId = widgetId;
          $scope.widget = new Widget(widgetId);
          $scope.widget_type = widget_type;
          $scope.gitFilterList(widgetId);
        };

        $scope.loadMoreRecords = function(widgetId) {

          if ($scope.widget.busy) {
            return;
          }
          $scope.widget.busy = true;
          var page_url = "";
          if ($scope.widget.page > 1) {
            page_url = "?page=" + $scope.widget.page;
          }
          var url =  url_base + widgetId + ".json" + page_url;

          $http.get(url).
            success(function(data) {
              var items = data.items;
              for (var i = 0; i < items.length; i++)
              {
                $scope.widget.items.push(items[i]);
              }
              $scope.widget.page++;
              $scope.widget.busy = false;
            }).
            error(function(data, status, headers, config) {
              $scope.widget.busy = false;
              $scope.status=status;
            });
        };

        $scope.extractRecords = function()
        {
          if($scope.appliedFilters.length > 0)
          {
            $scope.widget.items = [];

            var widget_type = $scope.widget_type;

            for (var i = 0 ; i < $scope.widget.originalItems.length ; i++) {
              if (widget_type === 'files')
                var contentStr = $scope.widget.originalItems[i].name;
              else if(widget_type === 'email')
                var contentStr = $scope.widget.originalItems[i].sender + " " + $scope.widget.originalItems[i].subject;
              else if(widget_type === 'calendar')
                var contentStr = $scope.widget.originalItems[i].title+ " " + $scope.widget.originalItems[i].creator;
              else if(widget_type === 'note')
                var contentStr = $scope.widget.originalItems[i].name;

              for (var j = 0 ; j < $scope.appliedFilters.length ; j++) {
                var checker = new RegExp($scope.appliedFilters[j], 'i');
                if (checker.test(contentStr)) {
                  $scope.widget.items.push($scope.widget.originalItems[i]);
                  break;
                };
              };
            };
          }
          else
          {
            for (var i = 0 ; i < $scope.widget.originalItems.length ; i++) {
              $scope.widget.items.push($scope.widget.originalItems[i]);
            }
          }
          $scope.widget.page++;
          $scope.widget.busy = false;
        }
    });

mashboard.directive('whenscrollends', function() {
  return {
      restrict: "A",
      link: function(scope, element, attrs) {
          var visibleHeight = element.height();
          var threshold = 100;

          element.scroll(function() {
              var scrollableHeight = element.prop('scrollHeight');
              var hiddenContentHeight = scrollableHeight - visibleHeight;

              if (hiddenContentHeight - element.scrollTop() <= threshold) {
                  // Scroll is almost at the bottom. Loading more rows
                  scope.$apply(attrs.whenscrollends);
              }
          });
      }
  };
});

mashboard.factory("Widget", function() {
  // Define the Widget2 function
  var Widget = function(widgetId) {
    this.widgetId = widgetId;
    this.items = [];
    this.originalItems = [];
    this.page = 1;
    this.busy = false;
  };

  // Return a reference to the function
  return (Widget);
});

mashboard.factory("SelectedFilters", function(){
  return [];
})

function searchWidgets() {
  var str = $("#searchText").val();

  if (str != null && str != '')
  {
    $(".table-hover > tbody > tr").hide();

    $("td:contains('"+str+"')").each(function(){
      $(this).parent("tr").show();
    });
  }
  else
  {
    // Show all  rows.
    $(".table-hover > tbody > tr").show();
  }

};

function searchWidgetByFilter(filter_string)
{
  $("#searchText").val(filter_string);
  searchWidgets();
}


// MATT'S JS
  function widgetResize() {

      $( ".widget" ).resizable(
        	{
            handles: 'n,s,se,sw,ne,nw',
            distance: 30,
            grid: 20,
            minHeight: 150,
            minWidth: getWidth(),
            maxWidth: getWidth(),
			alsoResize: '#widget-body'
  		}
  	);
  }

function widgetDrag() {


  	$('.main').height(theHeight);

  	$( ".widget" ).draggable(
    		{
            containment: ".main",
            scroll: false,
            grid: [20,20],
            stack: ".widget",
      		distance: 30,
      		handle: "h3"

    		}
  	);
  	var originalWindowWidth=$(window).width();
  	$('.main').height()-800;
}

function getWidth() { return $(".widget").width(); }

$(".widget").data({
  	'originalLeft': $(".widget").css('left'),
  	'origionalTop': $(".widget").css('top')
});

function resetPosition() {
  	$(".widget").css({
    	  	'left': $(".widget").data('originalLeft'),
    		'top': $(".widget").data('origionalTop')
	});
	var originalWindowWidth = $(window).width();
};

$(".reset").click(function() { resetPosition() });

var theHeight = $(window).height();

var originalWindowWidth=$(window).width();

$( document ).ready(function() {
 widgetDrag(); widgetResize();
});


$(window).resize(function() {

	if (($(window).width()) != (originalWindowWidth)) { 
		resetPosition(); 		
		getWidth(); 
	}  
});

mashboard.controller('FilterController', function($scope, $rootScope, $http, SelectedFilters ) {
  $scope.filter_panel = 'add_panel';
  $scope.SelectedFilters = SelectedFilters;
  
  $scope.formData = {};
  $scope.formData.isSaving = false;
  $scope.filterApplied = true;

  $scope.FilterInit = function(widgetId)
  {
    
  };
  

  $scope.onClickAddFilter = function()                      // "+ ADD FILTER" button press in filter list panel
  {
    $scope.filter_panel = 'save_panel';
    $scope.submitted = false;
  };


  $scope.filterSelect = function(filter){                   // Checkbox press in filter list panel
    var checked = false;
    // $scope.$parent.widget.items = [];
    // $scope.$parent.widget.busy = false;
    $scope.filterApplied = false;
    // idx = $scope.SelectedFilters.indexOf(filter.filter);
    idx = $scope.$parent.appliedFilters.indexOf(filter.filter);
    if( idx > -1 )
    {
      $scope.$parent.appliedFilters.splice(idx, 1);
    }
    else
    {
      $scope.$parent.appliedFilters.push(filter.filter);
      checked = true;
    }

    var formdata = {
      'checked': checked
    };

    $http({
      method: 'POST',
      url : '/filters/' + filter.id + "/change_check/",
      data : formdata,
      headers :{'content-Type' : 'application/json'}
    })
    .success(function(data){
      $scope.filterApplied = true;
      $scope.onClickApplyFilter();
    });
  };

  $scope.filterNameChange = function()
  {
    if ($scope.formData.filtername && $scope.formData.filtername.length > 0) {
      $scope.submitted = false;
    }
  }

  $scope.onClickApplyFilter = function()
  {
    $scope.$parent.widget.items = [];
    $scope.$parent.widget.busy = false;
    $scope.$parent.widget.page = 1;
    $scope.$parent.loadMoreRecords($scope.$parent.widgetId);
  };


  $scope.addFilterSubmit = function(widgetId)               // "SAVE & APPLY" button press in add filter panel(add filter form submit)
  {
    if ($scope.formData.filtername && $scope.formData.filtername.length > 0 && $scope.formData.filtername.trim().length > 0) {
      var new_filter_name = $scope.formData.filtername.trim();

      var formdata = {
        'filtername' : $scope.formData.filtername,
        'widgetid' : widgetId
      }

      $scope.formData.isSaving = true;

      $http({
        method : 'POST',
        url : '/filters',
        data : formdata,
        headers :{'content-Type' : 'application/json'}
      })
      .success(function(data){
        if (data.success){
          $scope.formData.isSaving = false;
          $scope.$parent.filters.push(data.success.filter);
          $scope.$parent.appliedFilters.push(data.success.filter.filter);
          $scope.formData.filtername = "";
          $scope.filter_panel = 'add_panel';
          $scope.onClickApplyFilter();
        }
      });
    }
    else
    {
      $scope.submitted = true;
      return;
    }
  };


  $scope.onClickModifyFilter = function(index)              // Modify button press in filter list panel
  {
    // var edit_filter = $scope.filters[index];
    var edit_filter = $scope.$parent.filters[index];
    $scope.formData.edit_filter = edit_filter;
    $scope.formData.selected_index = index;
    $scope.formData.original_filter_name = edit_filter.filter;
    $scope.filter_panel = 'edit_panel';
    $scope.submitted = false;
  };

  $scope.editFilterNameChange = function()
  {
    if ($scope.formData.edit_filter.filter && $scope.formData.edit_filter.filter.length > 0) {
      $scope.submitted = false;
    }
  }

  $scope.editFilterSubmit = function() {                    // "SAVE & APPLY" button press in edit filter panel(edit filter form submit)
    if ($scope.formData.edit_filter.filter && $scope.formData.edit_filter.filter.length > 0 && $scope.formData.edit_filter.filter.trim().length > 0) {
      var new_filter_name = $scope.formData.edit_filter.filter.trim();

      if ($scope.formData.original_filter_name == new_filter_name) {
        $scope.filter_panel = 'add_panel';
        return;
      };

      var formdata = {
        'filtername' : new_filter_name
      }

      $scope.formData.isSaving = true;

      $http({
        method : 'PUT',
        url : '/filters/' + $scope.formData.edit_filter.id,
        data : formdata,
        headers :{'content-Type' : 'application/json'}
      })
      .success(function(data){
        if (data.success){
          $scope.formData.isSaving = false;
          $scope.$parent.filters[$scope.formData.selected_index] = $scope.formData.edit_filter;
          $scope.filter_panel = 'add_panel';

          idx = $scope.$parent.appliedFilters.indexOf($scope.formData.original_filter_name);

          if( idx > -1 )
          {
            $scope.$parent.appliedFilters[idx] = new_filter_name;
            $scope.onClickApplyFilter();
          }
        }
      });
    }
    else
    {
      $scope.submitted = true;
      return;
    }
  };


  $scope.onClickDeleteFilter = function()                  //"Delete" button press in filter edit panel
  {
    $scope.formData.isSaving = true;

    $http({
      method : 'DELETE',
      url : '/filters/' + $scope.formData.edit_filter.id,
      headers :{'content-Type' : 'application/json'}
    })
    .success(function(data){
      if (data.success){
        idx = $scope.$parent.appliedFilters.indexOf($scope.formData.edit_filter.filter);
        if( idx > -1 )
        {
          $scope.$parent.appliedFilters.splice(idx, 1);
          $scope.onClickApplyFilter();
        }

        $scope.$parent.filters.splice($scope.formData.selected_index, 1);
        $scope.filter_panel = 'add_panel';
        $scope.formData.isSaving = false;
      }
    });
  };
  

  $scope.onClickBack = function(widgetId)                 //"Back" button pressed in filter add panel and filter edit panel(to filter list panel)
  {
    $scope.filter_panel = 'add_panel';
    $scope.submitted = false;
  };
});