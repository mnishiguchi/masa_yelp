# Utilities that help deliver errors in a single, unified format with clear, useful information.
# Adopted from chriskottom/jello-server
# https://github.com/chriskottom/jello-server/blob/master/app/controllers/concerns/responds_with_error.rb
module RespondsWithError
  private

  def render_error(status, resource = nil)
    render status: status,
           json: (resource ? { error: resource } : nil)
  end

  def respond_with_not_found(exception = nil)
    render_error :not_found, status: 404,
                             name: "Not found",
                             message: exception&.message
  end

  def respond_with_validation_error(model, errors = nil)
    render_error :unprocessable_entity, status: 422,
                                        name: "Validation failed",
                                        errors: (errors || model.errors)
  end
end
