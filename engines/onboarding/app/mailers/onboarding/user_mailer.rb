module Onboarding
  class UserMailer < ActionMailer::Base
    default from: 'info@katuma.org'

    def welcome_email(user)
      @user = user
      @url  = 'http://www.katuma.org'
      mail(to: @user.email, subject: 'Welcome to katuma.org!')
    end
  end
end
