require 'digest/sha2'

class MobileToken < ActiveRecord::Base
  attr_accessible :token, :user_id
  
  belongs_to :user
  
  class << self
    # Determine if the token/email pairing is correct.
    def is_token_valid(email, token)
      results = MobileToken.find(:all, :joins => :user, :conditions => ["users.email = ? and mobile_tokens.token = ?", email, token])
      return results.any?
    end
  end
end
