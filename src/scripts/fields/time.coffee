Formbuilder.registerField 'time',

  order: 25

  view: """
    <% var time = rf.get(Formbuilder.options.mappings.INITIAL_TIME), timeparts = time.split(/[ :]+/); %>
    <div class='input-line'>
      <span class='hours'>
        <input type="text" style="width:70px;" value='<%= (timeparts[0] > 12 || timeparts[0] < 1) ? ((timeparts[0] > 12) ? '12' : '1') : timeparts[0] %>'/>
        <label>HH</label>
      </span>
      <span class='above-line'>:</span>
      <span class='minutes'>
        <input type="text" style="width:70px;" value='<%= (timeparts[1] > 60 || timeparts[1] < 0) ? ((timeparts[1] > 60) ? '60' : '0') : timeparts[1] %>'/>
        <label>MM</label>
      </span>
      <span class='above-line'>:</span>
      <span class='seconds'>
        <input type="text" style="width:70px;" value='<%= (timeparts[2] > 60 || timeparts[2] < 0) ? ((timeparts[2] > 60) ? '60' : '0') : timeparts[2] %>'/>
        <label>SS</label>
      </span>
      <span class='am_pm'>
        <select>
          <option <%= (timeparts[3] == 'AM') ? 'selected="selected"' : '' %> >AM</option>
          <option <%= (timeparts[3] == 'PM') ? 'selected="selected"' : '' %> >PM</option>
        </select>
      </span>
    </div>
  """

  edit: """
    <%= Formbuilder.templates['edit/initial_time']() %>
  """

  addButton: """
&nbsp;&nbsp;
    <span class="symbol"><span class="fa fa-clock-o"></span></span> Time
  """

  defaultAttributes: (attrs) ->
    attrs.options.initial_time = 'HH:MM:SS AA'
    attrs