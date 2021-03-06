Formbuilder.registerField 'textarea',

  name: 'Long Answer'

  order: 5

  view: """
    <textarea class='rf-size-<%= rf.get(Formbuilder.options.mappings.SIZE) %>'></textarea>
  """

  edit: """
  <%= Formbuilder.templates['edit/populate_from']({ rf: rf }) %>
  """

  addButton: """
    <span class="fa fa-paragraph"></span> Paragraph
  """

  defaultAttributes: (attrs) ->
    attrs.options.size = 'small'
    attrs
