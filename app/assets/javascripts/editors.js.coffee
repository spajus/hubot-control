window.editors = []

initEditor = (clazz, type, lineNumbers=false) ->
  $(clazz).each (idx, elem) ->
    window.editors.push CodeMirror.fromTextArea elem,
      mode: type
      theme: 'night'
      viewportMargin: Infinity
      lineNumbers: lineNumbers
      tabSize: 2

initEditors = ->
  initEditor '.json-editor', { name: 'javascript', json: true }
  initEditor '.javascript-editor', 'javascript', true
  initEditor '.coffeescript-editor', 'coffeescript', true
initEditors()

$('[data-toggle="tab"]').on 'click', ->
  for editor in window.editors
    setTimeout(editor.refresh, 100)
