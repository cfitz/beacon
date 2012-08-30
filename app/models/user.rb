class User < Neo4j::Rails::Model
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :omniauthable
         #, :validatable, removing this since we currently only want google oauth
  # Setup accessible (or protected) attributes for your model
  attr_accessible :given_name, :surname, :email, :password, :password_confirmation, :remember_me, :approved, :admin

  has_n(:affiliation).from(:CorporateBody)

  property :approved, :type => :boolean
  property :admin, :type => :boolean
  property :given_name, :type => String
  property :surname, :type => String
  
 
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
   
   
   def self.find_for_open_id(access_token, signed_in_resource=nil)
       data = access_token.info
       if user = User.where(:email => data["email"].downcase ).first
         return user
       elsif data["email"].downcase.include?("wmu.se")
         User.create!(:email => data["email"].downcase, :password => Devise.friendly_token[0,20], :approved => true)
       else
         User.create!(:email => data["email"].downcase, :password => Devise.friendly_token[0,20])
       end
     end
   
   
   def self.find_for_google_oauth2(access_token, signed_in_resource=nil)
      data = access_token.info
      user = User.find(:email => data["email"].downcase)
      if user
        return user
      elsif data["email"].downcase.include?("wmu.se")
        return User.create!(:email => data["email"].downcase, :password => Devise.friendly_token[0,20], :approved => true)
      else
        return User.create!(:email => data["email"].downcase, :password => Devise.friendly_token[0,20])
      end
   end




end
