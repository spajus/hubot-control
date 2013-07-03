$.ajaxSetup
  headers:
    'X-CSRF-Token': $('meta[name="csrf-token"]').attr('content')

$ ->
  if location.hash != ''
    $('a[href="'+location.hash+'"]').tab('show')

  $('a[data-toggle="tab"]').on 'shown', (e) ->
    location.hash = $(e.target).attr('href').substr(1)

  $('.js-loader').on 'click', (event) ->
    $(event.target || event.currentTarget).button('loading')

  vimMode = $ '#vim-mode'
  if $.cookie('editor.keyMap') == 'vim'
    vimMode.addClass('active')
  else
    vimMode.removeClass('active')

  vimMode.on 'click', (e) ->
    setTimeout ->
      if vimMode.hasClass 'active'
        keyMap = 'vim'
      else
        keyMap = 'default'
      $.cookie 'editor.keyMap', keyMap
      for editor in window.editors
        editor.setOption 'keyMap', keyMap
        editor.refresh()
        editor.focus()
    , 100
