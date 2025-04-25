class StaticFilesController < ApplicationController
  def serve_static
    path = request.path
    file_path = Rails.root.join('public', 'react-client', path.sub(/^\//, ''))
    
    if File.exist?(file_path)
      send_file file_path
    else
      render plain: "File not found", status: 404
    end
  end
end