# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
    @user = user
    if @user
      case @user.role_name
      when :staff
        staff_ability
      when :manager
        manager_ability
      when :admin
        admin_ability
      end
    end
  end

  def staff_ability
    can [:read], Staff, company_id: @user.company.id
    can [:read], Category, company_id: @user.company.id
    can [:read], Company, id: @user.company.id
    can [:read], FileProp
    can [:read], ImageProp
    can [:read], TextProp
    can [:read], Product
    can [:read], SubCategory
  end

  def manager_ability
    can :manage, Staff, company_id: @user.company.id
    can :manage, Category, company_id: @user.company.id
    can :read, Company, id: @user.company.id
    # TODO: 権限が強すぎるのでおそらく修正が必要
    can :manage, FileProp
    can :manage, ImageProp
    can :manage, TextProp
    can :manage, Product
    can [:read, :create, :update], SubCategory
  end

  def admin_ability
    can :manage, Staff
    can :manage, Category
    can :manage, Company
    can :manage, FileProp
    can :manage, ImageProp
    can :manage, TextProp
    can :manage, Product
    can [:read, :create, :update], SubCategory
  end
end
