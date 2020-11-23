class UsersController < ApplicationController
    load_and_authorize_resource
    before_action :set_user, only: [:edit_profile,:update_profile,:profile]
    def profile_index
        @users = User.all
    end
    
    def edit_profile
    end
    
    def update_profile
        respond_to do |format|
            if @user.update(user_params)
                format.html { redirect_to edit_profile_url(@user), notice: 'User was successfully updated.' }
                format.json { render :profile, status: :ok, location: @user }
            else
                format.html { render :edit_profile }
                format.json { render json: @lesson.errors, status: :unprocessable_entity }
            end
        end
    end
    
    def profile
    end
    
    private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end
    
    def user_params
      user_attrs = []
      user_attrs << :role if current_user.is? :admin
      user_attrs << :level if current_user.is? :admin
      user_attrs << :points if current_user.is? :admin
      params.require(:user).permit(user_attrs)
    end
    
end
