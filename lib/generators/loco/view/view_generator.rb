class Loco::ViewGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('../templates', __FILE__)

  def create_view
    file_path = File.join Rails.root, 'app', 'assets', 'javascripts', 'views',
      *class_path, "#{file_name}.coffee"
    class_name = (class_path + [file_name]).map(&:camelcase).join('.')
    data = File.read find_in_source_paths('view.coffee')
    data.sub! '#{name}', class_name
    create_file file_path, data
  end

  def create_methods
    file_path = File.join Rails.root, 'app', 'assets', 'javascripts', 'views',
      *class_path, "#{file_name}.coffee"
    args.each.with_index do |meth_name, index|
      prev_meth_def = if index == 0
        "render: ->\n"
      else
        "\n  #{args[index - 1]}: ->\n"
      end
      meth_def = "\n  #{meth_name}: ->\n"
      inject_into_file file_path, meth_def, after: prev_meth_def
    end
  end

  def create_namespaces_inside_intializer
    file_path = File.join Rails.root, 'app', 'assets', 'javascripts', 'initializers', 'loco.coffee'
    class_path.each.with_index do |name, index|
      prev_namespace_def = if index == 0
        nil
      else
        current_name = class_path[0, index].map(&:camelcase).join('.')
        "App.Views.#{current_name} = {}\n"
      end
      current_name = class_path[0, index + 1].map(&:camelcase).join('.')
      namespace_def = "App.Views.#{current_name} = {}\n"
      if prev_namespace_def.nil?
        prepend_file file_path, namespace_def
      else
        inject_into_file file_path, namespace_def, after: prev_namespace_def
      end
    end
  end
end
