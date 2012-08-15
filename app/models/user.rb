class User < Neo4j::Rails::Model
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :approved, :admin
  property :approved, :type => :boolean
  property :admin, :type => :boolean
  

  def to_s
     email
   end

   def approved?
     self.approved ||= false
     return self.approved
   end
   
   def admin?
     self.admin ||= false
     return self.admin
   end

   def active_for_authentication? 
     super && approved? 
   end 

   def inactive_message 
     if !approved? 
       :not_approved 
     else 
       super # Use whatever other message 
     end 
   end
   
   
   def self.find_for_google_oauth2(access_token, signed_in_resource=nil)
       data = access_token.info
       user = User.find(:email => data["email"].downcase)

       unless user
           user = User.create(
   	    		   email: data["email"],
   	    		   password: Devise.friendly_token[0,20]
   	    		  )
       end
       user
   end




end
