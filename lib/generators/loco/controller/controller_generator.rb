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
    file_path = File.join Rails.root, 'app', 'assets', 'javascripts', 'controllers',
      *class_path, "#{file_name}.coffee"
    class_name = (class_path + [file_name]).map(&:camelcase).join('.')
    data = File.read find_in_source_paths('controller.coffee')
    data.sub! '#{name}', class_name
    create_file file_path, data
  end

  def create_methods
    file_path = File.join Rails.root, 'app', 'assets', 'javascripts', 'controllers',
      *class_path, "#{file_name}.coffee"
    args.each.with_index do |meth_name, index|
      prev_meth_def = if index == 0
        "initialize: ->\n"
      else
        "\n  #{args[index - 1]}: ->\n"
      end
      meth_def = "\n  #{meth_name}: ->\n"
      inject_into_file file_path, meth_def, after: prev_meth_def
    end
  end
end
