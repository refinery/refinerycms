class UsersController < ActionController::Base
  
  
  def index
    @freelancer = Freelancer.find_all_by_name(param[:name])
    @user = User.find(1)
  end
end