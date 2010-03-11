require 'digest/sha1'

class User < ActiveRecord::Base

  # Hack: Allow "rake gems:install" to run when this class is missing its gem dependency.
  # For further clarification on why, refer to:
  # https://rails.lighthouseapp.com/projects/8994/tickets/780-rake-gems-install-doesn-t-work-if-plugins-are-missing-gem-dependencies
  if defined? AASM
    include AASM # include the library which will give us state machine functionality.
    aasm_column :state
    aasm_initial_state :pending
    aasm_state :passive
    aasm_state :pending, :enter => :make_activation_code
    aasm_state :active,  :enter => :do_activate

    aasm_event :register do
      transitions :from => :passive, :to => :pending, :guard => Proc.new {|u| !(u.crypted_password.blank? && u.password.blank?) }
    end

    aasm_event :activate do
      transitions :from => :pending, :to => :active
    end
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
  attr_accessible :login, :email, :password, :password_confirmation, :plugins, :reset_code

  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  def self.authenticate(login, password)
    u = find_in_state :first, :active, :conditions => {:login => login} # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end

  # Encrypts some data with the salt.
  def self.encrypt(password, salt)
    Digest::SHA1.hexdigest("--#{salt}--#{password}--")
  end

  # Encrypts the password with the user salt
  def encrypt(password)
    self.class.encrypt(password, salt)
  end

  def authenticated?(password)
    crypted_password == encrypt(password)
  end

  def plugins=(plugin_names)
    unless self.new_record? # don't add plugins when the user_id is NULL.
      self.plugins.delete_all

      plugin_names.each do |plugin_name|
        self.plugins.find_or_create_by_name(plugin_name) if plugin_name.is_a?(String)
      end
    end
  end

  def authorized_plugins
    self.plugins.collect {|p| p.name} | Refinery::Plugins.always_allowed.names
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

  def delete_reset_code
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

  def make_activation_code
    self.deleted_at = nil
    self.activation_code = Digest::SHA1.hexdigest( Time.now.to_s.split(//).sort_by {rand}.join )
  end

  def do_activate
    @activated = true
    self.activated_at = Time.now.utc
    self.deleted_at = self.activation_code = nil
  end

end
