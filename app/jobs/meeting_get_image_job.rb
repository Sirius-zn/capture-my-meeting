class MeetingBroadcastJob < ApplicationJob
    queue_as :default
    @@img_cache = {}

    # Retrieve image for the meeting
    # @param user_id - ID of user asking for an image
    # @param meeting_id - meeting room of the user
    def perform(user_id, meeting_id)
        path = "#{Rails.root}/uploads/#{meeintg_id}/test.png"
        fixed_image = nil
        status = false
        if File.exists?(path)
            File.open(path, 'rb') do |file|
                fixed_image = 'data:image/png;base64,'
                if File.exists?(path)
                    img = Base64.encode64(file.read)
                    hex = Digest::MD5.hexdigest(img)
                    if @@img_cache[meeting_id] == nil || (hex != @@img_cache[meeting_id])
                        @@img_cache[meeting_id] = hex
                        fixed_image += img
                        status = true
                    end
                end
            end
        end

        # status `true` if succssfully read image from path
        ActionCable.server.broadcast "meetings_#{meeting_id}_#{user_id}", image: fixed_image, status: status, from: "get_image"
    end
end
