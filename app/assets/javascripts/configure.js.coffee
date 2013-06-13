includeScript = (el) ->
  editor_id = $(el.target).data('target')
  textarea = $ '#' + editor_id

  script = $(el.target).data('script')
  json = JSON.parse textarea.val()
  json.push script unless script in json
  textarea.val JSON.stringify(json)

  for editor in editors
    if editor.getTextArea().id == editor_id
      editor.setValue textarea.val()

  false

$ ->
  ($ '#editor-tabs').addClass 'tab-content'
  ($ '.include-script').on 'click', includeScript

