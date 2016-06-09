Formbuilder.registerField 'date',

  name: 'Date'

  order: 20

  view: """
    <% var date = rf.get(Formbuilder.options.mappings.INITIAL_DATE), dateparts = date.split('-'); %>
    <div class='input-line'>
      <span class='month'>
        <input type="text" value='<%= (dateparts[0] > 12 || dateparts[0] < 1) ? ((dateparts[0] > 12) ? '12' : '1') : dateparts[0] %>'/>
        <label>MM</label>
      </span>
      <span class='above-line'>-</span>
      <span class='day'>
        <input type="text" value="<%= (dateparts[1] > 31 || dateparts[1] < 1) ? ((dateparts[1] > 31) ? '31' : '1') : dateparts[1] %>"/>
        <label>DD</label>
      </span>
      <span class='above-line'>-</span>
      <span class='year'>
        <input type="text" value="<%= (dateparts[2] < 1) ? '1' : dateparts[2] %>"/>
        <label>YYYY</label>
      </span>
    </div>
  """

  edit: """
    <%= Formbuilder.templates['edit/initial_date']() %>
  """

  addButton: """
    <span class="fa fa-calendar"></span> Date
  """
  defaultAttributes: (attrs) ->
    attrs.options.initial_date = 'MM - DD - YYYY'
    attrs