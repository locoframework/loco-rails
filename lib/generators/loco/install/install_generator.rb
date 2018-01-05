class Loco::InstallGenerator < Rails::Generators::Base
  source_root File.expand_path('../templates', __FILE__)

  def install
    generate 'loco:initializer'
    generate 'loco:file_injector'
    generate 'loco:notification_center'
    rake 'loco:install:migrations'
  end
end
