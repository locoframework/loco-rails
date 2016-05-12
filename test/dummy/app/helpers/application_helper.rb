module ApplicationHelper
  include Loco::Helpers

  def admin_panel?
    controller_path.split('/').first == 'admin'
  end

  def user_panel?
    controller_path.split('/').first == 'user'
  end
end
