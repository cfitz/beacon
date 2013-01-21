module ControllerMacros
  def login_admin
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      @user =  FactoryGirl.create(:admin) # Using factory girl as an example
      sign_in @user
    end
  end

  def login_user
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      @user = FactoryGirl.create(:user)
      sign_in @user
    end
  end

  def logout_user
    after(:each) do
      if @user
        sign_out @user
      end
    end
  end

end
