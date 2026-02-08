require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  test 'registration_confirmation' do
    user = User.new(username: 'michael', email: 'michael@example.com', password: 'password')
    user.save
    user.confirm_token = 'token'
    mail = UserMailer.registration_confirmation(user)
    assert_equal 'Registration Confirmation', mail.subject
    assert_equal [user.email], mail.to
    assert_equal ['from@example.com'], mail.from
    assert_match user.username,               mail.body.encoded
    assert_match user.confirm_token,          mail.body.encoded
  end
end
