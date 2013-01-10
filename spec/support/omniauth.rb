OmniAuth.config.test_mode = true

OmniAuth.config.add_mock(:wmu_google_oauth2, {  :provider    => "google_oauth2", 
                                  :uid         => "1234", 
                                  :info   => {   :name       => "Bob hope",
                                                      :email   => "bhope@wmu.se",
                                                      :urls       => {:Twitter => "www.twitter.com/bobster"}},
                                  :credentials => {   :auth => "lk2j3lkjasldkjflk3ljsdf"} })
 
OmniAuth.config.add_mock(:google_oauth2, {  :provider    => "google_oauth2", 
                                  :uid         => "1234", 
                                  :info   => {   :name       => "Bob hope",
                                                      :email   => "bhope@gmail.com",
                                                      :urls       => {:Twitter => "www.twitter.com/bobster"}},
                                  :credentials => {   :auth => "lk2j3lkjasldkjflk3ljsdf"} })