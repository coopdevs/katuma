def authenticate_as(user)
  allow(controller).to receive(:authenticate).and_return(true)
  allow(controller).to receive(:current_user).and_return(user)
end
