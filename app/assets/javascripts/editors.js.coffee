window.editors = []

initEditor = (clazz, type, options = {validator: null}) ->
  $(clazz).each (idx, elem) ->
    window.editors.push CodeMirror.fromTextArea elem,
      mode: type
      theme: 'solarized dark'
      gutters: ["CodeMirror-lint-markers"]
      viewportMargin: Infinity
      lineNumbers: true
      lintWith: options.validator
      tabSize: 2

initEditors = ->
  initEditor '.shell-editor', 'shell'
  initEditor '.json-editor', { name: 'javascript', json: true }, validator: CodeMirror.jsonValidator
  initEditor '.javascript-editor', 'javascript', validator: CodeMirror.javascriptValidator
  initEditor '.coffeescript-editor', 'coffeescript', validator: CodeMirror.coffeeValidator
initEditors()

$('[data-toggle="tab"]').on 'click', ->
  for editor in window.editors
    setTimeout(editor.refresh, 100)
