class Loco::ModelGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('../templates', __FILE__)

  def create_model
    model_template = File.read find_in_source_paths('model.coffee')
    model_template.gsub! '#{name}', class_name
    model_template.gsub! '#{plural_name}', plural_name
    model_template.sub! '#{attributes}', attr_def
    create_file file_path, model_template
  end

  private

    def file_path
      path = File.join Rails.root, 'app', 'assets', 'javascripts', 'models',
        *class_path, *file_name.split(/\.|\//).map(&:underscore)
      path.to_s + '.coffee'
    end

    def class_name
      (class_path + [file_name]).map(&:camelcase).join('.')
    end

    def attr_def
      attr_def = args.map{ |s| s.split ':' }.map do |attr_name, attr_type|
        attr_template = File.read find_in_source_paths('attribute.coffee')
        attr_template.gsub! '#{attr_name}', attr_name
        attr_template.gsub! '#{remote_name}', attr_name.underscore
        attr_template.gsub! '#{attr_type}', (attr_type || 'String').capitalize
        attr_template
      end
      attr_def.empty? ? '{}' : "\n" + attr_def.join("\n")
    end
end
