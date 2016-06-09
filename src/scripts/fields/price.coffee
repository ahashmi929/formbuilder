Formbuilder.registerField 'price',

  name: 'Price'

  order: 45

  view: """
    <div class='input-line'>
      <span class='above-line'>PKR</span>
      <span class='dolars'>
        <input type='text' />
        <!--<label>PKR</label>-->
      </span>
    </div>
  """

  edit: ""

  addButton: """
    <span class="fa fa-money"></span> Price
  """
