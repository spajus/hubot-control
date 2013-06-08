output = $('#output')
stream = ->
  clearTimeout(stream_timeout)
  $.ajax
    url: gon.hubot_stream_url
    dataType: 'text'
    success: (data) ->
      if data
        orig_val = output.val()
        orig_val += "\n" if orig_val
        output.val(orig_val + data)
        output.scrollTop(output[0].scrollHeight - output.height())
    complete: ->
      if 'interact' in location.href
        stream_timeout = setTimeout(stream, 5000)

stream_timeout = setTimeout(stream, 5000)

input = $('#input')
input.on 'keypress', (e) ->
  if (e.keyCode || e.which) == 13
    message = input.val()
    input.val('')
    $.ajax
      url: gon.hubot_stream_url
      method: 'post'
      data: { message: message }
      success: -> stream()

