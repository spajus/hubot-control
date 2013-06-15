includeScript = (el) ->

  editor_id = $(el.currentTarget).data('target')
  textarea = $ '#' + editor_id

  script = $( '#' + $(el.currentTarget).data('source')).val()

  json = JSON.parse textarea.val()
  if script in json
    alert "#{script} is already included"
  else
    json.push script
  textarea.val JSON.stringify(json, undefined, 2)

  for editor in editors
    if editor.getTextArea().id == editor_id
      editor.setValue textarea.val()

  false

$ ->
  ($ '#editor-tabs').addClass 'tab-content'
  ($ '.include-script').on 'click', includeScript

