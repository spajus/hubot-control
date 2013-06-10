log = $('#log')
updateLog = ->
  clearTimeout(update_timeout)
  $.ajax
    url: gon.log_stream_url
    method: 'post'
    dataType: 'text'
    success: (data) ->
      if data
        log.val(data)
        log.scrollTop(log[0].scrollHeight - log.height())
    complete: ->
      if /\/log$/.test location.href
        update_timeout = setTimeout(updateLog, 5000)

update_timeout = setTimeout(updateLog, 5000)
