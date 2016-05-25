class Loco::InstallGenerator < Rails::Generators::Base
  source_root File.expand_path('../templates', __FILE__)

  def install
    generate 'loco:initializer'
    generate 'loco:js_assets_structure'
    generate 'loco:file_injector'
    rake 'loco:install:migrations'
  end
end
