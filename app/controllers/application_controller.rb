class ApplicationController < ActionController::Base
  before_action :set_i18n_locale_from_params

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

  protected
    def set_i18n_locale_from_params
      if params[:locale]
        if I18n.available_locales.map(&:to_s).include?(params[:locale])
          I18n.locale = params[:locale]
        else
          flash.now[:notice] =
          "#{params[:locale]} translation not available"
          logger.error flash.now[:notice]
        end
      else
        I18n.locale = I18n.default_locale
      end
    end
end
