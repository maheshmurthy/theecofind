class Notifier < ActionMailer::Base  
    
  def password_reset_instructions(user)  
    subject       "Password Reset Instructions"  
    from          "team@theecofind.com"  
    recipients    user.email  
    sent_on       Time.now  
    body          :edit_password_reset_url => edit_password_reset_url(user.perishable_token)  
  end

  def confirmation_email(user)
    subject       "Account Created"
    from          "team@theecofind.com"
    recipients    user.email
    sent_on       Time.now
    body          :edit_confirmation_url => default_url_options[:host] +
      "/password_resets/" + user.perishable_token + "/edit"
  end
end
