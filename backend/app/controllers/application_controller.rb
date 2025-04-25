class ApplicationController < ActionController::Base
  def react_client
    render file: Rails.root.join('public', 'react-client', 'index.html'), layout: false
  end
end