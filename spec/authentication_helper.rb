module AuthenticationHelper
  def authenticate_as(user)
    if respond_to?(:sign_in)
      sign_in user
    end
    Grant::User.current_user = user
  end
end
