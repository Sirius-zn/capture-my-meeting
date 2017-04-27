class MeetingChannel < ApplicationCable::Channel
  def subscribed
    stream_from "meetings_#{params['id']}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def send_image(data)
    MeetingBroadcastJob.perform_now data['filename'], data['image'], data['id']
  end
end
