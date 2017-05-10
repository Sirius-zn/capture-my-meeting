class MeetingChannel < ApplicationCable::Channel
    include SessionsHelper
    @@peers = {}
    def subscribed
      stream_from "meetings_#{params['id']}"
    end

    def unsubscribed
        # Any cleanup needed when channel is unsubscribed
    end

  def send_image(data)
    MeetingBroadcastJob.perform_now data['user_id'], data['filename'], data['image'], data['id'], data['src'], data['dest']
  end

  def send_box(data)
      dirname = "#{Rails.root}/uploads/#{data['meeting_id']}/#{data['user_id']}/imgs"

      # Write Image to Disk
      coordinates = "#{data['src']['x']} #{data['src']['y']} #{data['dest']['x']} #{data['dest']['y']}"
      File.open("#{dirname}/coordinates.txt", "w+") { |f| f.write "#{coordinates}" }
      status = true;

      ActionCable.server.broadcast "meetings_#{data['meeting_id']}", status: status
  end

  def send_peer_id(data)
    mid = data['meeting_id']
    if @@peers.nil?
      puts "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! --- NIL"
    end

    if @@peers[mid].nil?
      @@peers[mid] = [] if @@peers[mid].nil?
      puts "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! --- NIL []"
    end

    # puts "PEERS!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!#{@peers[meeting_id]}"
    @@peers[mid] << data['peer_id']
    puts @@peers
    ActionCable.server.broadcast "meetings_#{mid}", peers: @@peers[mid]
  end
end
