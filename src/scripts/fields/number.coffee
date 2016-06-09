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
        if _.nested(model, 'changed.options.calculation_type') != undefined
          model.expression()

        if _.nested(model, 'changed.options.total_sequence') != undefined
          totalSequence = _.nested model, 'changed.options.total_sequence'
          @parentModel().totalColumn model.get('uuid'), totalSequence
        model

      @on "change", (model) ->
        if _.nested(model, 'changed.options.min') != undefined
          model.validatemin()
        if _.nested(model, 'changed.options.max') != undefined
          model.validatemax()
        model

      @on "change", (model) ->
        if _.nested(model, 'changed.options.initial_value') != undefined
          max = parseInt(@get('options.max'))
          initialval = parseInt(@get('options.initial_value'))



    attrs.validatemin = () ->
      min = parseInt(@get('options.min'))
      max = parseInt(@get('options.max'))

      if isNaN(min)
        @set('options.min', 0)

      if min > max
        @set('options.min', max)
      if isNaN(max)
        @set('options.max', 500)
    attrs

    attrs.validatemax = () ->
      min = parseInt(@get('options.min'))
      max = parseInt(@get('options.max'))

      if isNaN(max)
        @set('options.max', 0)

      if max < min
        @set('options.min', 0)

    attrs

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