require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe UsersController do
   include ControllerMacros
   include Devise::TestHelpers
   
    it "should use UsersController" do
       controller.should be_an_instance_of(UsersController)
    end
    
    describe "#index non-admin" do
      login_user
      
      it "should not allow non-admin users to see the page" do
        get :index
        response.should_not be_success
        flash[:notice].should == "You currently do not have permissions to view this section. If this is an error, please contact the system administrator."
      end
    end
    
    describe "#index as admin" do
      
      login_admin
      
      it "should allow an admin user to see the index page" do
        get :index
        puts flash[:notice]
        response.should_not redirect_to('/')
        response.should be_success
      end
      
       it "should show users awaiting approval" do
          User.should_receive(:find_all_by_approved).with(false)
          get :index, {:approved => "false"}
          response.should_not redirect_to('/')
          response.should be_success
        end      
    end
    
   describe "#edit admin" do
      login_admin
      it "should get the user by id for updating" do
        User.should_receive(:find).twice.and_return(@user)
        get :edit, :id=> @user.id
        response.should_not redirect_to('/')
        response.should be_success
      end
     end

      describe "#edit non-admin" do
       it "should get the user by id for updating" do
         get :edit, :id=>1
         response.should redirect_to('/')
         response.should_not be_success
       end
      end
 
      describe "#show non-admin" do
         login_user
         it "should not allow non-admin users to see the page" do
           get :show, :id=> 1
           response.should redirect_to('/')
           response.should_not be_success
         end  
       end

       describe "#show admin" do
          login_admin
          it "should not allow non-admin users to see the page" do
            get :show, :id => 1
            response.should_not redirect_to('/')
            response.should be_success
          end
        end
    
         describe "#update admin" do
           login_admin
           it "should update the user when given the proper infomation" do 
              User.should_receive(:find).twice.and_return(@user)
              @user.should_receive(:update_attributes).once.and_return(true)
              get :update, :id => @user.id, :approved => true, :email => "foobar@foofoo.com"
              response.should redirect_to("/")
              flash[:notice].should == "Successfully updated User."
           end

           it "should not update the user when given crap" do
             bad_user = FactoryGirl.create(:user_not_approved)
             User.should_receive(:find).once.with(bad_user.id).and_return(bad_user)
             User.should_receive(:find).once.with(@user.id).and_return(@user)
             
             bad_user.should_receive(:update_attributes).and_return(false)
             get :update, :id => bad_user.id, :approved => true, :email => "this is not an email."
             response.should_not redirect_to("/")
             response.should render_template("users/edit")
             flash[:notice].should == "Problem updating user"
           end
         end

         describe "#update non admin" do

           it "should redirect to root when not admin" do
             get :update, :id => 666, :approved => true, :email => "foobar@foofoo.com"
             response.should redirect_to("/")
             flash[:notice].should == "You currently do not have permissions to view this section. If this is an error, please contact the system administrator."
           end
         end
   
   
       describe "DELETE destroy as admin" do
         login_admin
         
          it "destroys the requested user" do
            expect {
              delete :destroy, {:id => @user.to_param}
            }.to change(User, :count).by(-1)
          end

          it "redirects to the user list" do
            delete :destroy, {:id => @user.to_param}
            response.should redirect_to(users_url)
          end
        end
 
      describe "DELETE destroy as non-admin" do
          it "destroys the requested user" do
            expect {
              delete :destroy, {:id => 1 }
            }.to_not change(User, :count).by(-1)
          end

          it "redirects to the user list" do
            delete :destroy, {:id => 1 }
            response.should redirect_to("/")
          end
      end
 
   
end