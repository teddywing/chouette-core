class ErrorsController < ApplicationController
  def not_found
    render template: 'errors/not_found', status: 404, formats: [:html]
  end

  def server_error
    render template: 'errors/server_error', status: 500, formats: [:html]
  end

  def not_allowed
    render template: 'errors/not_found', status: 403, formats: [:html]
  end
end

