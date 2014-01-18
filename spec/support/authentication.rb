def authenticate_as(user)
  controller.stub(:authenticate).and_return(true)
  controller.stub(:current_user).and_return(user)
end
