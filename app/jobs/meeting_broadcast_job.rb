class MeetingBroadcastJob < ApplicationJob
    queue_as :default

    # perform job
    # @param user_id - id of user
    # @param id - id of meeting
    # @param filename - image filename
    # @param image - the image itself in base64
    def perform(user_id, filename, image, id)
        dirname = "#{Rails.root}/uploads/#{id}/#{user_id}/imgs"

        # Write Image to Disk
        status = true
        begin
            png = Base64.decode64(image['data:image/png;base64,'.length .. -1])
            File.open("#{dirname}/#{filename}", 'wb') { |f| f.write(png) }
        rescue
            status = false
        end

        # status `true` if image successfully read to disk
        ActionCable.server.broadcast "meetings_#{id}_#{user_id}", status: status, from: "send_image"
    end

end
