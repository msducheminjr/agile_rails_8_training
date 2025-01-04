class ApplicationController < ActionController::Base
  include Authentication
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  include ActiveStorage::SetCurrent

  def root_url
    store_index_url
  end

  def root_path
    store_index_path
  end
end
