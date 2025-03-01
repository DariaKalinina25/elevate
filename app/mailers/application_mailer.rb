# frozen_string_literal: true

# Base mailer for handling application-wide email configurations.
class ApplicationMailer < ActionMailer::Base
  default from: 'from@example.com'
  layout 'mailer'
end
