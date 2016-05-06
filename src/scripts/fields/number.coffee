Formbuilder.registerField 'number',

  name: 'Number'

  order: 30

  view: """
    <input type='text' class="calculated" value="<%= rf.get(Formbuilder.options.mappings.NUMERIC.CALCULATION_DISPLAY) %>" <%= rf.get(Formbuilder.options.mappings.NUMERIC.CALCULATION_DISPLAY) ? 'readonly="readonly"' : ''  %> />
    <% if (units = rf.get(Formbuilder.options.mappings.UNITS)) { %>
      <%= units %>
    <% } %>
  """

  edit: """
    <%= Formbuilder.templates['edit/initial_value']() %>
    <%= Formbuilder.templates['edit/total']({rf:rf}) %>
    <%= Formbuilder.templates['edit/min_max']({rf:rf}) %>
  """
  addButton: """
    <span class="fb-icon-number"></span> Number
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

      console.log(min)
      console.log(max)
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