module CommonHelpers
  def update_value_attr_for sel
    page.execute_script "$('#{sel}').attr('value', $('#{sel}').val());"
  end
end