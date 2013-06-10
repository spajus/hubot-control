$.ajaxSetup
  headers:
    'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')

$ ->
  if location.hash != ''
    $('a[href="'+location.hash+'"]').tab('show')

  $('a[data-toggle="tab"]').on 'shown', (e) ->
    location.hash = $(e.target).attr('href').substr(1)
