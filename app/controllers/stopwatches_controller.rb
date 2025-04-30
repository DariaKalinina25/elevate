# frozen_string_literal: true

class StopwatchesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_stopwatch, only: %i[stop destroy]
  before_action :load_stopwatches, only: %i[index create stop destroy]

  def index
    @stopwatch = current_user.stopwatches.started.last || build_stopwatch
  end

  def create
    @stopwatch = build_stopwatch(stopwatch_params)

    respond_with_success(stopwatches_path) if @stopwatch.save
  end

  def stop
    @stopwatch.stop
    @stopwatch = build_stopwatch

    respond_with_success(stopwatches_path)
  end

  def destroy
    @stopwatch.destroy

    respond_with_success(stopwatches_path)
  end

  private

  def set_stopwatch
    @stopwatch = current_user.stopwatches.find(params[:id])
  end

  def load_stopwatches
    @stopwatches = current_user.stopwatches.stopped_recent
  end

  def build_stopwatch(params = {})
    current_user.stopwatches.build(params)
  end

  def stopwatch_params
    params.expect(stopwatch: [:title])
  end
end
