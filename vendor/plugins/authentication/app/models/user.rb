require 'digest/sha1'

class User < ActiveRecord::Base
  #-------------------------------------------------------------------------------------------------
  # Authentication

  acts_as_authentic do |c|
    c.perishable_token_valid_for 10.minutes

    # http://www.binarylogic.com/2008/11/23/tutorial-easily-migrate-from-restful_authentication-to-authlogic/
    c.act_like_restful_authentication = true
    c.transition_from_restful_authentication = true
  end

  def deliver_password_reset_instructions!(request)
    reset_perishable_token!
    UserMailer.deliver_reset_notification(self, request)
  end

  #-------------------------------------------------------------------------------------------------

  serialize :plugins_column # Array # this is seriously deprecated and will be removed later.

  has_many :plugins, :class_name => "UserPlugin", :order => "position ASC"

  def plugins=(plugin_titles)
    unless self.new_record? # don't add plugins when the user_id is NULL.
      self.plugins.delete_all

      plugin_titles.each do |plugin_title|
        self.plugins.find_or_create_by_title(plugin_title) if plugin_title.is_a?(String)
      end
    end
  end

  def authorized_plugins
    self.plugins.collect {|p| p.title} | Refinery::Plugins.always_allowed.titles
  end

  def ui_deletable?(current_user = self)
    !self.superuser and User.count > 1 and (current_user.nil? or self.id != current_user.id)
  end

protected

  # before filter
  def encrypt_password
    return if password.blank?
    self.salt = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{login}--") if new_record?
    self.crypted_password = encrypt(password)
  end

  def password_required?
    crypted_password.blank? || !password.blank?
  end

end
