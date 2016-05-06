class UsersController < ApplicationController
  def index
    if current_user.admin?
      @users = User.all
    end
  end
end
