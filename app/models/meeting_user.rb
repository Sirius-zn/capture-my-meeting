class MeetingUser < ActiveRecord::Base
    validates_presence_of :user_id
    validates_presence_of :meeting_id
    validates_presence_of :user_role

    validates :user_role, inclusion: { in: %w(presenter audience), message: "%(value) is not a valid role" }

    belongs_to :user
    belongs_to :meeting
    after_create_commit :create_image_folder


    def create_image_folder
        dirname = "#{Rails.root}/uploads/#{self.meeting_id}/#{self.user_id}"
        FileUtils.mkdir_p(dirname) unless File.directory?(dirname)
        FileUtils.mkdir_p("#{dirname}/imgs") unless File.directory?("#{dirname}/imgs")
        # FileUtils.mkdir_p("#{dirname}/box") unless File.directory?("#{dirname}/box")
    end
end
