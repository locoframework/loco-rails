# frozen_string_literal: true

module Loco
  module Jobs
    module ResourceSerializer
      module_function

      def serialize(resource)
        { 'class' => resource.class.name, 'id' => resource.id }
      end

      def deserialize(hash)
        hash['class'].constantize.find_by(id: hash['id'])
      end
    end
  end
end
