module ApiConventionRefinements
  refine Hash do
    def snakecase_keys
      # https://apidock.com/rails/v4.0.2/Hash/deep_transform_keys
      deep_transform_keys { |k| k.to_s.underscore.to_sym }
    end

    def camelize_keys
      deep_transform_keys { |k| k.to_s.camelize(:lower) }
    end
  end
end
