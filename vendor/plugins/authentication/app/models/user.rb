require 'digest/sha1'

class User < ActiveRecord::Base

  def register!
    logger.warn("*** User::register! has now been deprecated from the Refinery API. ***")
  end

  def activate!
    logger.warn("*** User::activate! has now been deprecated from the Refinery API. ***")
  end

  # Virtual attribute for the unencrypted password
  attr_accessor :password

  #validates_presence_of     :login, :email # handled by other checks
  #validates_presence_of     :password,                   :if => :password_required? # handled by other checks
  validates_presence_of     :password_confirmation,      :if => :password_required?
  validates_length_of       :password, :within => 4..40, :if => :password_required?
  validates_confirmation_of :password,                   :if => :password_required?
  validates_length_of       :login,    :within => 3..40
  validates_length_of       :email,    :within => 3..100
  validates_uniqueness_of   :login, :email, :case_sensitive => false
  before_save :encrypt_password

  serialize :plugins_column # Array # this is seriously deprecated and will be removed later.

  has_many :plugins, :class_name => "UserPlugin", :order => "position ASC"

  # prevents a user from submitting a crafted form that bypasses activation
  # anything else you want your user to change should be added here.
  attr_accessible :login, :email, :password, :password_confirmation, :plugins, :reset_code, :state

  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  def self.authenticate(login, password)
    user = find_by_state :active.to_s, :conditions => {:login => login} # need to get the salt
    user.present? && user.authenticated?(password) ? user : nil
  end

  # Encrypts some data with the salt.
  def self.encrypt(password, salt)
    Digest::SHA1.hexdigest("--#{salt}--#{password}--")
  end

  # Activate by default.
  def before_create
    self.state = 'active'
  end

  # Encrypts the password with the user salt
  def encrypt(password)
    self.class.encrypt(password, salt)
  end

  def authenticated?(password)
    crypted_password == encrypt(password)
  end

  def plugins=(plugin_titles)
    unless self.new_record? # don't add plugins when the user_id is NULL.
      self.plugins.delete_all

      plugin_titles.each do |plugin_title|
        self.plugins.find_or_create_by_title(plugin_title) if plugin_title.is_a?(String)
      end

      self.save(false)
    end
  end

  def authorized_plugins
    self.plugins.collect {|p| p.title} | Refinery::Plugins.always_allowed.titles
  end

  def remember_token?
    remember_token_expires_at && Time.now.utc < remember_token_expires_at
  end

  # These create and unset the fields required for remembering users between browser closes
  def remember_me
    remember_me_for 2.weeks
  end

  def remember_me_for(time)
    remember_me_until time.from_now.utc
  end

  def remember_me_until(time)
    self.remember_token_expires_at = time
    self.remember_token            = encrypt("#{email}--#{remember_token_expires_at}")
    save(false)
  end

  def forget_me
    self.remember_token_expires_at = nil
    self.remember_token            = nil
    save(false)
  end

  # Returns true if the user has just been activated.
  def recently_activated?
    @activated
  end

  def ui_deletable?(current_user = self)
    !self.superuser and User.count > 1 and (current_user.nil? or self.id != current_user.id)
  end

  def create_reset_code
    @reset = true
    code = Digest::SHA1.hexdigest( Time.now.to_s.split(//).sort_by {rand}.join )
    self.attributes = {:reset_code => code[0..6]}
    save(false)
  end

  def recently_reset?
    @reset
  end

  def delete_reset_code!
    self.attributes = {:reset_code => nil}
    save(false)
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
