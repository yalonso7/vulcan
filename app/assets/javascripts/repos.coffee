# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

ready = ->
  jQuery ->
    # $('#projects-search').on('input', search_projects)
    $('#pull-requests-datatable').footable().on('footable_filtering', filter_projects)
    
$(document).on('turbolinks:load', ready)