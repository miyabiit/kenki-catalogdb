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
    can [:read], Staff, company_id: @user.company_id
    can [:read], Category, company_id: @user.company_id
    can [:read], Company, id: @user.company_id
    can [:read], FileProp, company_id: @user.company_id
    can [:read], ImageProp, company_id: @user.company_id
    can [:read], TextProp, company_id: @user.company_id
    can [:read], Product
    can [:read], StockProduct
    can [:read], SubCategory, company_id: @user.company_id
  end

  def manager_ability
    can :read, Staff, company_id: @user.company_id
    can :manage, Category, company_id: @user.company_id
    can :read, Company, id: @user.company_id
    can :manage, FileProp, company_id: @user.company_id
    can :manage, ImageProp, company_id: @user.company_id
    can :manage, TextProp, company_id: @user.company_id
    can :manage, Product
    can [:read], StockProduct
    can :manage, StockProduct, company_id: @user.company_id
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
    can :manage, StockProduct
    can [:read, :create, :update], SubCategory
  end
end
