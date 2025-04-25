class StaticFilesController < ApplicationController
  def serve_static
    # Strip the `/react-client` prefix from the request path
    path = request.path.sub(/^\/react-client/, '')

    # Construct the full path to the file
    file_path = Rails.root.join('public', 'react-client', path)

    # Log the final file path for debugging purposes
    Rails.logger.info "Serving static file from: #{file_path}"

    # If the file exists, serve it, otherwise return a 404 error
    if File.exist?(file_path)
      send_file file_path, disposition: 'inline'
    else
      Rails.logger.error "File not found: #{file_path}"
      render plain: "File not found", status: 404
    end
  end
end