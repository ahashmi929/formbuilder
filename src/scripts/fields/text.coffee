Formbuilder.registerField 'text',

  name: 'Short Answer'

  order: 0

  view: """
    <% var initial_value = rf.get(Formbuilder.options.mappings.INITIAL_VALUE); %>
    <input type='text' value='<%= initial_value %>' class='rf-size-<%= rf.get(Formbuilder.options.mappings.SIZE) %>' />
  """

  edit: """
  <% var minlength = rf.get(Formbuilder.options.mappings.MINLENGTH); %>
  <% var maxlength = rf.get(Formbuilder.options.mappings.MAXLENGTH); %>

  <%= Formbuilder.templates['edit/initial_value']() %>
  <%= Formbuilder.templates['edit/min_max_length']({ rf: rf }) %>
  """

  addButton: """
    <span class="fb-icon-text"></span> Text
  """

  defaultAttributes: (attrs, formbuilder) ->

    attrs.initialize = () ->

      @on "change", (model) ->
        if _.nested(model, 'changed.options.minlength') != undefined
          model.validatemin()
        if _.nested(model, 'changed.options.maxlength') != undefined
          model.validatemax()
        model

    attrs.validatemin = () ->
      minlength = parseInt(@get('options.minlength'))
      maxlength = parseInt(@get('options.maxlength'))

      if isNaN(minlength)
        @set('options.minlength', 0)

      if minlength > maxlength
        @set('options.minlength', maxlength)
      if isNaN(maxlength)
        @set('options.maxlength', 500)
    attrs

    attrs.validatemax = () ->
      minlength = parseInt(@get('options.minlength'))
      maxlength = parseInt(@get('options.maxlength'))

      if isNaN(maxlength)
        @set('options.maxlength', 0)

      console.log(minlength)
      console.log(maxlength)
      if maxlength < minlength
        @set('options.minlength', 0)
    attrs
