class Loco::ControllerGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('../templates', __FILE__)

  def create_namespace_controllers
    file_path = File.join Rails.root, 'app', 'assets', 'javascripts', 'controllers'
    class_path.each.with_index do |name, index|
      class_name = class_path[0, index+1].map(&:camelcase).join('.')
      current_file_path = File.join(file_path, *class_path[0, index+1]) + '.coffee'
      data = File.read find_in_source_paths('controller.coffee')
      data.sub! '#{name}', class_name
      create_file current_file_path, data
    end
  end

  def create_controller
    class_name = (class_path + [file_name]).map(&:camelcase).join('.')
    data = File.read find_in_source_paths('controller.coffee')
    data.sub! '#{name}', class_name
    data.sub! '#{methods_def}', methods_def.join('')
    create_file file_path, data
  end

  private

    def methods_def
      args.map.with_index do |name, index|
        "\n  #{name}: ->\n"
      end
    end

    def file_path
      File.join Rails.root, 'app', 'assets', 'javascripts', 'controllers',
        *class_path, "#{file_name}.coffee"
    end
end
