class Ability
  include CanCan::Ability

  def initialize(user)

    user ||= User.new # guest user (not logged in)
    if user.is? :admin
      can :manage, :all
    elsif user.is? :contributor
      can :update, :all
    elsif user.is? :default
      can :read, :all
    else
      can :read, :all
    end
  end
end

