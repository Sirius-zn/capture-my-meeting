class MeetingChannel < ApplicationCable::Channel
  def subscribed
    stream_from "meetings_#{params['id']}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def send_image(data)
    ActionCable.server.broadcast "meetings_#{data['id']}", image: data['image']
  end
end
