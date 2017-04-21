class MeetingsController < ApplicationController
	skip_before_filter :verify_authenticity_token
	before_action :set_meeting, only: [:show, :edit, :update, :destroy]

    include MeetingsHelper

    def show
        @mu = MeetingUser.find_by(:meeting_id => @meeting.id, :user_id => current_user.id)
    end

    # GET /meetings/new
    def new
    end

    # POST /meetings
    def create
        @meeting = Meeting.new :code => generate_code, :password => generate_password, :user_id => current_user.id

        respond_to do |format|
            if @meeting.save
                @mu = MeetingUser.new(:meeting_id => @meeting.id, :user_id => current_user.id, :user_role => params[:user_role])
                @mu.save!
                format.html { redirect_to @meeting, notice: 'Meeting created.' }
                format.json { render action: 'show', status: :created, location: @meeting }
            else
                format.html { render action: 'new' }
                format.json { render json: @meeting.errors, status: :unporcessable_entity }
            end
        end
    end

    # GET /meetings/1/edit
    def edit
    end

    # PATCH /meetings/1
    def update
    end

    private
        def set_meeting
            @meeting = Meeting.find(params[:id])
        end

        def meeting_params
            params.require(:user_role)
        end
end
