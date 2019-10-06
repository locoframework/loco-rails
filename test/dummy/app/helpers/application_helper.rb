module ApplicationHelper
  include Loco::Helpers

  def admin_panel?
    controller_path.split('/').first == 'admin'
  end

  def user_panel?
    controller_path.split('/').first == 'user'
  end

  def body_styles
    if admin_panel?
      'background-color: #99734B;'
    elsif user_panel?
      'background-color: #73994B;'
    else
      ''
    end
  end
end
