class MeetingChannel < ApplicationCable::Channel
    @@peers = {}
    def subscribed
      stream_from "meetings_#{params['id']}"
    end

    def unsubscribed
        # Any cleanup needed when channel is unsubscribed
    end

  def send_image(data)
    MeetingBroadcastJob.perform_now data['filename'], data['image'], data['id'], data['src'], data['end']
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
