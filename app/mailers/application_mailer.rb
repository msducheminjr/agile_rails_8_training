class ApplicationMailer < ActionMailer::Base
  helper ApplicationHelper
  default from: "Stateless Code <statelesscode@example.com>"
  layout "mailer"
end
