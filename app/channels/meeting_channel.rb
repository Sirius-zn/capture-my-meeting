class MeetingChannel < ApplicationCable::Channel
    include SessionsHelper

    def subscribed
        stream_from "meeting_#{params['id']}_#{params['uid']}"
    end

    def unsubscribed
        # Any cleanup needed when channel is unsubscribed
    end

    def send_image(data)
        MeetingBroadcastJob.perform_now data['user_id'], data['filename'], data['image'], data['id']
    end

    def get_image(data)
        MeetingGetImageJob.perform_now data['user_id'], data['meeting_id']
    end

    def send_box(data)
        dirname = "#{Rails.root}/uploads/#{data['meeting_id']}/#{data['user_id']}/imgs"

        # Write Image to Disk
        coordinates = "#{data['src']['x']} #{data['src']['y']} #{data['dest']['x']} #{data['dest']['y']}"
        File.open("#{dirname}/coordinates.txt", "w+") { |f| f.write "#{coordinates}" }
        status = true;

        ActionCable.server.broadcast "meetings_#{data['meeting_id']}_#{data['user_id']}", status: status
    end
end
