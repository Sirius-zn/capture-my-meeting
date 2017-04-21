class MeetingsController < ApplicationController
	skip_before_filter :verify_authenticity_token
	before_action :set_meeting, only: [:show, :edit, :update, :destroy]

    # GET /meetings/new
    def new
    end

    # POST /meetings
    def create

    end

    # GET /meetings/1/edit
    def edit
    end

    # PATCH /meetings/1
    def update
    end

    private
        def set_meeting
            @meeting = Meeting.find(params[:code])
        end

        def meeting_params
            params.permit(:code, :password)
        end
end
