class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :confirmable, :lockable


        
         
  ROLES = [ :admin, :contributor, :default ]

  def is?( requested_role )
    self.role == requested_role.to_s
  end
  
end
