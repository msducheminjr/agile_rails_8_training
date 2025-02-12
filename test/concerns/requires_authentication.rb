module RequiresAuthentication
  extend ActiveSupport::Concern

  def ensure_logged_out!(user)
    if Session.find_by(user: user)
      # logout
      assert_difference("Session.count", -1) do
        delete session_url
      end
    end
  end

  private
    def no_access_assertions!
      assert_redirected_to new_session_url
      assert_equal "You must login first.", flash[:notice]
    end
end
