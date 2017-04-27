class MeetingBroadcastJob < ApplicationJob
  queue_as :default

  def perform(filename, image, id)
    dirname = "#{Rails.root}/uploads/#{id}"

    # Write Image to Disk
    png = Base64.decode64(image['data:image/png;base64,'.length .. -1])
    File.open("#{dirname}/#{filename}", 'wb') { |f| f.write(png) }
    status = true;
    # Sends an object with {status: true/false, image:"data if applicable"}
    # path = "#{dirname}/test.png"
    # returnData = {:status => false}
    # if File.exists?(path)
    #   File.open(path, 'rb') do |file|
    #     d = 'data:image/png;base64,'
    #     if File.exists?(path)
    #       img = Base64.encode64(file.read)
    #       hex = Digest::MD5.hexdigest(img)
    #       if @img_cache == nil || (hex != @img_cache)
    #         @img_cache = hex
    #         d += img
    #         returnData[:data] = d
    #         returnData[:status] = true
    #       end
    #     end
    #   end
    # end

    ActionCable.server.broadcast "meetings_#{id}", image: image, status: status
  end
end
