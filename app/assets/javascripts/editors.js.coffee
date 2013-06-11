window.editors = []

initEditor = (clazz, type, options = {lineNumbers: false, validator: null}) ->
  $(clazz).each (idx, elem) ->
    window.editors.push CodeMirror.fromTextArea elem,
      mode: type
      theme: 'night'
      viewportMargin: Infinity
      lineNumbers: options.lineNumbers
      lintWith: options.validator
      tabSize: 2

initEditors = ->
  initEditor '.json-editor', { name: 'javascript', json: true }, validator: CodeMirror.jsonValidator
  initEditor '.javascript-editor', 'javascript', lineNumbers: true, validator: CodeMirror.javascriptValidator
  initEditor '.coffeescript-editor', 'coffeescript', lineNumbers: true, validator: CodeMirror.coffeeValidator
initEditors()

$('[data-toggle="tab"]').on 'click', ->
  for editor in window.editors
    setTimeout(editor.refresh, 100)
