class RegistrationsController < Devise::RegistrationsController


  def create
    if User.all.count >= 150
        flash[:alert] = 'Registrations are currently closed, but please check back soon'
        redirect_to register_path and return
    else
        super
    end

  end
  
  #def new
    #super
  #end
  
  def edit
    super
  end
  
  def update
    super
  end
  
  
end