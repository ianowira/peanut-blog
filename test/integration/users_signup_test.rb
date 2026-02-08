require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  def setup
    ActionMailer::Base.deliveries.clear
  end

  test 'invalid signup information' do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, params: { user: { username: '',
                                         email: 'user@invalid',
                                         password: 'foo' } }
    end
    # assert_template 'users/new'
  end

  test 'valid signup information with account activation' do
    get signup_path
    assert_difference 'User.count', 1 do
      post users_path, params: { user: { username: 'Example User',
                                         email: 'user@example.com',
                                         password: 'password' } }
    end
    assert_equal 1, ActionMailer::Base.deliveries.size
    user = User.find_by(email: 'user@example.com')
    assert_not user.email_confirmed?
    # Try to log in before activation.
    get login_path
    post login_path, params: { session: { email: user.email,
                                          password: 'password' } }
    assert_nil session[:user_id]

    # Invalid activation token
    get confirm_email_user_path('invalid token')
    assert_not user.reload.email_confirmed?

    # Valid activation token
    get confirm_email_user_path(user.confirm_token)
    assert user.reload.email_confirmed?
    follow_redirect!
    # assert_template 'sessions/new'
    assert_not_empty flash[:success]

    # Log in after activation
    post login_path, params: { session: { email: user.email,
                                          password: 'password' } }
    assert_redirected_to user
    follow_redirect!
    # assert_template 'users/show'
    assert is_logged_in?
  end
end
