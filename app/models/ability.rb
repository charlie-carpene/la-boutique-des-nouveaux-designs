# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    if user.present?
      can :read, Category
      can :read, Cart, user: user
      can :read, Item
      can [:read, :create], Order, user: user
      can [:read, :create], Shop
      can :manage, CartItem, cart: { user: { id: user.id } }
      can :manage, User, id: user.id
      can :manage, Address, user: user
      if user.is_maker
        can :manage, Shop, id: user.shop.id
        can :manage, Item, shop_id: user.shop.id
        can :read, OrderItem
        can :update, Order, shop: { id: user.shop.id }
      end
    end

    if user.admin.present?
      can :destroy, Shop
    end
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
  end
end
