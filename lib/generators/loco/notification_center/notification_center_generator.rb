class Loco::NotificationCenterGenerator < Rails::Generators::Base
  source_root File.expand_path('../templates', __FILE__)

  def create_dir_with_file
    directory ".", File.join(Rails.root, 'app')
  end
end
