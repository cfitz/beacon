module ControllerMacros
  def login_admin
    before(:each) do
      User.all.each { |f| f.delete }
      @request.env["devise.mapping"] = Devise.mappings[:admin]
      sign_in FactoryGirl.create(:admin) # Using factory girl as an example
    end
  end

  def login_user
    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      sign_in FactoryGirl.create(:user)
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