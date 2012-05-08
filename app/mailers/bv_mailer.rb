class BvMailer < ActionMailer::Base
  default :from => "support@bar-view.com"
  
  def user_welcome_email(user)
    @user = user
    
    mail(:to => @user.email, :subject => "bar-view.com registration")
  end
  
  def bar_registration_email(bar)
    @bar = bar
    
    mail(:to => @bar.email, :subject => "bar-view.com registration")
  end
  
  def bar_verification_email(bar)
    @bar = bar
    
    mail(:to => @bar.email, :subject => "bar-view.com verification")
  end
  
  def support_alert_email(bar)
    @bar = bar
    
    mail(:to => "support@bar-view.com", :subject => "Signup from #{ @bar.name } (#{ @bar.address })")
  end
end
