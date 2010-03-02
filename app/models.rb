# http://ohm.keyvalue.org/
require 'bcrypt'

class User < Ohm::Model
  attribute   :login
  index				:login
  attribute   :full_name
  attribute   :hash
  attribute		:isadmin
  list        :information

  # assert_unique :login
  
  def self.add_user(login,pass,fn,a)
    u = User.create(:login => login, :full_name => fn, :isadmin => a)
    u.password = pass
    u.save
  end
  
  def password
    BCrypt::Password.new(self.hash)
  end
  
  def password=(str)
    self.hash = BCrypt::Password.create(str)
  end
  
  def self.login(login,pass)
    if user = self.find(:login => login).first
      return user if user.password == pass
    end
  end
  
  def is_admin?
    self.isadmin == "1" ? true : false
  end
end



# What the user uploads.

class Rules < Ohm::Model
  attribute  :filename
  attribute  :owner
  attribute  :date
  attribute :sha
  list  :rule_text 
  index :owner
  index :sha
end
