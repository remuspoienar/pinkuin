jQuery ->
  resourceOptionsContent = {}

  $('form').on 'change', '.role-role_type', (event) ->
    role_type = event.target.value

    resource_id = $(this).closest('.role-attributes').find('.role-resource_id')
    if role_type == 'specific'
      resource_type = $(this).closest('.role-attributes').find('.role-resource_type').val()
      if resourceOptionsContent[resource_type] != undefined
        resource_id.html(resourceOptionsContent[resource_type])
        resource_id.attr('disabled', null)
      else
        $.get("/resource_metadata/select_options.html?resource_type=#{resource_type}").done (data) ->
          resourceOptionsContent[resource_type] = data
          resource_id.html(data)
          resource_id.attr('disabled', null)
    else
      resource_id.html(null)
      resource_id.attr('disabled', true)
