class Meeting < ActiveRecord::Base
  after_create_commit :create_upload_folder
  validates_presence_of :password
  validates_presence_of :code
  validates_presence_of :user

  belongs_to :user

  has_many :meeting_contents
  has_many :meeting_users

  def authenticate?(str)
    str == self.password
  end

  def create_upload_folder
    # Create /uploads folder if it doesn't exist
    dirname = "#{Rails.root}/uploads"
    FileUtils.mkdir_p(dirname) unless File.directory?(dirname)
    # unless File.directory?(dirname)
    #   system("mkdir #{dirname}")
    # end

    # Create folder to store images if it doesn't exist
    dirname = "#{dirname}/#{self.id}"
    FileUtils.mkdir_p(dirname) unless File.directory?(dirname)
    # unless File.directory?(dirname)
    #   system("mkdir #{dirname}")
    # end
  end
end
