class EnrollmentsController < ApplicationController
  before_filter :require_logged_user, :only => [:new, :create, :edit, :update]

  def new
    @enrollment = Enrollment.new
    @event = Event.find(params[:event_id])
    @user_id = current_user.id
  end

  def create
    @enrollment = Enrollment.new(params[:enrollment])
    @event = Event.find(params[:enrollment][:event_id])

    if @enrollment.save
      @enrollment.update_counter_of_events_and_users "active"

      redirect_to event_path(@event), :notice => t("flash.enrollments.create.notice")
    end
  end

  def edit
    @enrollment = Enrollment.find(params[:id])
    @event = Event.find(params[:event_id])
    @option = params[:option]

    @authorized = authorized_access?(@event)

    @can_record_presence = @authorized && Date.today >= @event.start_date

    if @option == "active"
      @user_id = current_user.id

      if @enrollment.active?
        @message_type = "text-warning"
        @value = false
        @message_button = t("show.event.cancel_my_participation")
      else
        @message_type = "text-success"
        @value = true
        @message_button = t("show.event.participate")
      end
    elsif @option == "present"
      if @can_record_presence
        @user_id = @enrollment.user.id
        @user_name = @enrollment.user.name

        if @enrollment.present?
          @message_type = "text-warning"
          @value = false
          @message_button = t("show.event.undo_presence")
        else
          @message_type = "text-success"
          @value = true
          @message_button = t("show.event.record_presence")
        end
      else
        redirect_to event_path(@event), :notice => t("flash.unauthorized_access")
      end
    end
  end

  def update
    @enrollment = Enrollment.find(params[:id])
    @event = Event.find(params[:event_id])
    @option = params[:option]

    if @enrollment.update_attributes(params[:enrollment])
      @enrollment.update_counter_of_events_and_users @option

      redirect_to event_path(@event), :notice => t("flash.enrollments.update.notice")
    end
  end
end