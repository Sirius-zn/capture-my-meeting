class MeetingBroadcastJob < ApplicationJob
    queue_as :default
    @@img_cache = {}

    # perform job
    # filename - image filename
    # image - the image itself in base64
    # src - {x,y} of bounding box start
    # end - {x,y} of bounding box end
    def perform(user_id, filename, image, id, src, dest)
        dirname = "#{Rails.root}/uploads/#{id}/#{user_id}/imgs"

        # Write Image to Disk
        png = Base64.decode64(image['data:image/png;base64,'.length .. -1])
        File.open("#{dirname}/#{filename}", 'wb') { |f| f.write(png) }

        status = true
        ActionCable.server.broadcast "meetings_#{id}", image: image, status: status

        # Once your side is set up Sirius, uncomment the lines below and delete line 17-18
        # Path to merged picture
        # path = "#{Rails.root}/uploads/#{id}/test.png"
        # fixed_image = nil
        # status = false
        # if File.exists?(path)
        #     File.open(path, 'rb') do |file|
        #         fixed_image = 'data:image/png;base64,'
        #         if File.exists?(path)
        #             img = Base64.encode64(file.read)
        #             hex = Digest::MD5.hexdigest(img)
        #             if @@img_cache[id] == nil || (hex != @@img_cache[id])
        #                 @@img_cache[id] = hex
        #                 fixed_image += img
        #                 status = true
        #             end
        #         end
        #     end
        # end
        # ActionCable.server.broadcast "meetings_#{id}", image: fixed_image, status: status
    end

end
