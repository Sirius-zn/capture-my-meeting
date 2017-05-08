class MeetingsController < ApplicationController
  skip_before_filter :verify_authenticity_token
  before_action :set_meeting, only: [:show, :edit, :update, :destroy]

  include MeetingsHelper

  def join
    unless params[:code].present? || params[:password].present?
      redirect_to meeting_url
    end

    @meeting = Meeting.find_by(:code => params[:code])
    if @meeting.authenticate?(params[:password])
      mu = MeetingUser.find_by(:user_id => current_user.id, :meeting_id => @meeting.id)
      if (mu.nil?)
        mu = MeetingUser.new(:user_id => current_user.id, :meeting_id => @meeting.id, :user_role => params[:user_role])
        mu.save
      end

      redirect_to @meeting
    end
  end

  def show
    @mu = MeetingUser.find_by(:meeting_id => @meeting.id, :user_id => current_user.id)
    @api_key = Rails.application.secrets.api_key

    # TODO: Output error
    redirect_to meetings_url if @mu.nil?
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
