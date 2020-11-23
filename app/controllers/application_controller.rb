class ApplicationController < ActionController::Base
  # Catch all CanCan errors and alert the user of the exception
  protect_from_forgery with: :exception
  before_action :get_lessons
  rescue_from CanCan::AccessDenied do | exception |
    redirect_to root_url, alert: exception.message
  end
  before_action :configure_permitted_parameters, if: :devise_controller?
  
  
  
  def get_lessons #this is do get lessons to display in the lessons drop down in the header
      @lessons = Lesson.all
  end
  
  protected

  def configure_permitted_parameters
    #below needs to be tested. role should only be able to be set
    #on update. 
    if user_signed_in?
      update_attrs = [:password, :password_confirmation, :current_password]
      #update_attrs << :role if current_user.is? :admin
      devise_parameter_sanitizer.permit :account_update, keys: update_attrs
    end
  end
  
end
