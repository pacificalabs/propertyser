class ApplicationMailer < ActionMailer::Base
  layout 'mailer'
  default from: "Lee from PacificaLabs <zoilism@gmail.com>",
    bcc: "Lee from PacificaLabs <zoilism@gmail.com>",
    reply_to: "Lee from PacificaLabs <zoilism@gmail.com>",
    cc: "Support Desk <zoilism@gmail.com>"
end
