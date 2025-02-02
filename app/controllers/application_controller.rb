class ApplicationController < ActionController::Base
  around_action :switch_locale

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
    def switch_locale(&action)
      locale = params[:locale]&.to_sym || I18n.default_locale
      unless I18n.available_locales.include?(locale)
        flash.now[:notice] =
        "#{params[:locale]} translation not available"
        logger.error flash.now[:notice]
        locale = I18n.default_locale
      end
      I18n.with_locale(locale, &action)
    end
end
