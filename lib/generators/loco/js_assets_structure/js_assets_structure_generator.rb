class Loco::JsAssetsStructureGenerator < Rails::Generators::Base
  source_root File.expand_path('../templates', __FILE__)

  def create_dir_struct
    directory ".", File.join(Rails.root, 'app', 'assets', 'javascripts')
  end
end
