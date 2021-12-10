class Ability
  include CanCan::Ability

  def initialize(user)

    can [:edit, :update, :delete], Post do |post|
      post.user == user
    end

    can [:edit, :update, :delete], Comment do |comment|
      comment.user == comment
    end
  end
end
