# frozen_string_literal: true

# Controller for user timers
class TimersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_timer, only: %i[stop destroy]
  before_action :load_timers, only: %i[index create stop destroy]

  def index
    @timer = current_user.timers.started.last || build_timer
  end

  def create
    @timer = TimerCreator.new(
      user: current_user,
      duration_seconds: DurationParser.to_seconds(timer_params[:duration]),
      title: timer_params[:title]
    ).call

    respond_with_success(timers_path) if @timer.persisted?
  end

  def stop
    @timer.stop
    @timer = build_timer

    respond_with_success(timers_path)
  end

  def destroy
    @timer.destroy

    respond_with_success(timers_path)
  end

  private

  def set_timer
    @timer = current_user.timers.find(params[:id])
  end

  def load_timers
    @timers = current_user.timers.stopped_recent
  end

  def build_timer
    current_user.timers.build
  end

  def timer_params
    params.expect(timer: [:title, :duration])
  end
end
