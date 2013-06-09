window.editors = []
initEditors = ->
  $('.json-editor').each (idx, elem) ->
    window.editors.push CodeMirror.fromTextArea elem,
      mode: { name: 'javascript', json: true }
      theme: 'night'
      viewportMargin: Infinity
initEditors()

$('[data-toggle="tab"]').on 'click', ->
  for editor in window.editors
    editor.refresh()
