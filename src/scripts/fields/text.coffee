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
    <span class="fa fa-font"></span> Text
  """


