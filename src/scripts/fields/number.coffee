Formbuilder.registerField 'number',

  name: 'Number'

  order: 30

  view: """
    <% var initial_value = rf.get(Formbuilder.options.mappings.INITIAL_VALUE); %>
    <input type='text' value='<%= initial_value %>' class='rf-size-<%= rf.get(Formbuilder.options.mappings.SIZE) %>' />
  """

  edit: """
    <%= Formbuilder.templates['edit/initial_value_number']() %>
    <%= Formbuilder.templates['edit/total']({rf:rf}) %>
    <%= Formbuilder.templates['edit/min_max']({rf:rf}) %>
  """
  addButton: """
    <span class=""><small><b>123</b></small></span> Number
  """

  defaultAttributes: (attrs, formbuilder) ->
    attrs.insertion = () ->
      parentModel = @parentModel()
      if parentModel and parentModel.get('type') == 'table'
        totalColumn = parentModel.totalColumn @get('uuid')
        @attributes.options.total_sequence = totalColumn

    attrs.initialize = () ->
      @on "change", (model) ->
        if _.nested(model, 'changed.options.initial_value') != undefined
          max = parseInt(@get('options.max'))
          initialval = parseInt(@get('options.initial_value'))

    attrs.numericSiblings = () ->
      parentModel = @parentModel()
      if (parentModel)
        _.filter parentModel.childModels(), (i) ->
            i.get('type') is 'number' and i.get('uuid') != @get('uuid')
          , @
      else
        []

    attrs.expression = () ->
      calculation_type = @get('options.calculation_type')
      if calculation_type != ''
        operator = if calculation_type is 'SUM' then '+' else '*'
        numericSiblings = @numericSiblings()
        #Prefix with uuid_ and underscore '-' to prevent illegal identifiers
        @set('options.calculation_expression', _.map(numericSiblings, (model) -> 'uuid_' + model.get('uuid').replace(/-/g, '_')).join(operator))
        @set('options.calculation_display', '= ' + _.map(numericSiblings, (model) -> model.get('label')).join(operator))
        console.log(@get('options.calculation_expression'))
      else
        @set('options.calculation_expression', '')
        @set('options.calculation_display', '')
    attrs.canTotalColumn = () ->
      parent = @parentModel()
      parent and parent.get('type') is 'table'
    attrs.canAcceptCalculatedTotal = () ->
      @numericSiblings().length > 1
    attrs