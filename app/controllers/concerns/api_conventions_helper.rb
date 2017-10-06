module ApiConventionsHelper
  extend ActiveSupport::Concern

  included do
    def snakecase_keys(hash)
      # https://apidock.com/rails/v4.0.2/Hash/deep_transform_keys
      hash.deep_transform_keys { |k| k.to_s.underscore.to_sym }
    end

    def camelize_keys(hash)
      hash.deep_transform_keys { |k| k.to_s.camelize(:lower) }
    end
  end

  class_methods do
  end
end
