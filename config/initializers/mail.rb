ActionMailer::Base.delivery_method = :smtp
ActionMailer::Base.raise_delivery_errors = true
ActionMailer::Base.smtp_settings = {
    :address => "mail.theecofind.com",
    :port => 26,
    :domain => "www.theecofind.com",
    :authentication => :login,
    :user_name => "team+theecofind.com",
    :password => "gotIt123"
}
