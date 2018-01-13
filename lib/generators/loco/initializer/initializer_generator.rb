# frozen_string_literal: true

module Loco
  class InitializerGenerator < Rails::Generators::Base
    source_root File.expand_path('../templates', __FILE__)

    def copy_initializer_file
      copy_file 'initializer.rb', 'config/initializers/loco.rb'
    end
  end
end
