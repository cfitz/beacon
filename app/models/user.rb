class User < Neo4j::Rails::Model
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  attr_accessible :given_name, :surname, :email, :password, :password_confirmation, :remember_me, :approved, :admin
  
  before_validation :ensure_password
  before_save :ensure_person
  
  # Setup accessible (or protected) attributes for your model
  property :email, :index => :exact
  property :approved, :type => :boolean
  property :admin, :type => :boolean
  property :given_name, :type => String
  property :surname, :type => String
  property :encrypted_password, :type =>  NilClass
  
  ## Rememberable
  property :remember_created_at, :type => Time
  
  #Trackable
  property :sign_in_count, :type => Fixnum, :default => 0
  property :current_sign_in_at, :type => Time
  property :last_sign_in_at, :type => Time
  property :current_sign_in_ip, :type =>  String
  property :last_sign_in_ip, :type => String
  
  has_one(:person).from(Person, :user_profile)
  
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :omniauthable,
         :validatable #removing this since we currently only want google oauth
 
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
 
   def name
     "#{self.given_name} #{self.surname}"
   end
   
   def self.find_for_google_oauth2(access_token, signed_in_resource=nil)
      data = access_token.info
      user = User.find(:email => data["email"].downcase)
      if user
        return user
      elsif data["email"].downcase.include?("wmu.se")
        return User.create!(:email => data["email"].downcase, :surname => data["last_name"], :given_name => data["first_name"], :password => Devise.friendly_token[0,20], :approved => true)
      else
        return User.create!(:email => data["email"].downcase, :surname => data["last_name"], :given_name => data["first_name"], :password => Devise.friendly_token[0,20])
      end
   end

  protected
  
  # makes sure we have a password in the password prop even if they auth with google
  def ensure_password
    self.password ||= Devise.friendly_token[0,20]
  end
  
  # this makes sure the person has a person page
  def ensure_person
      self.person = Person.create(:name => self.name) unless self.person
  end


end
