class SessionsController < ApplicationController
  allow_unauthenticated_access only: %i[ new create ]
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { redirect_to new_session_url, alert: "Try again later." }

  def new
  end

  def create
    check_for_no_admin_scenario
    if user = User.authenticate_by(params.permit(:email_address, :password))
      start_new_session_for user
      redirect_to after_authentication_url
    else
      redirect_to new_session_path, alert: "Try another email address or password."
    end
  end

  def destroy
    terminate_session
    clear_site_data
    redirect_to new_session_path, notice: "You have successfully logged out."
  end

  private
    def check_for_no_admin_scenario
      if User.take.nil?
        user = User.new(params.permit(:email_address, :password))
        user.name = user.email_address.split("@")[0]
        user.save
      end
    end
end
