class MeetingBroadcastJob < ApplicationJob
  queue_as :default

  # perform job
  # filename - image filename
  # image - the image itself in base64
  # src - {x,y} of bounding box start
  # end - {x,y} of bounding box end
  def perform(filename, image, id, src, end)
    dirname = "#{Rails.root}/uploads/#{id}"

    # Write Image to Disk
    png = Base64.decode64(image['data:image/png;base64,'.length .. -1])
    File.open("#{dirname}/#{filename}", 'wb') { |f| f.write(png) }
    status = true;

    # ActionCable.server.broadcast "meetings_#{id}", image: image, status: status
  end
end
