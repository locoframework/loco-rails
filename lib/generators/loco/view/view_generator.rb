class Loco::ViewGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('../templates', __FILE__)

  def create_view
    class_name = (class_path + [file_name]).map(&:camelcase).join('.')
    data = File.read find_in_source_paths('view.coffee')
    data.sub! '#{name}', class_name
    data.sub! '#{methods_def}', methods_def.join('')
    create_file file_path, data
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

  private

    def methods_def
      args.map.with_index do |name, index|
        "\n  #{name}: ->\n"
      end
    end

    def file_path
      File.join Rails.root, 'app', 'assets', 'javascripts', 'views',
        *class_path, "#{file_name}.coffee"
    end
end
