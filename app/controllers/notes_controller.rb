# frozen_string_literal: true

class NotesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_note, only: [:show, :edit, :update, :destroy]

  def index
    @notes = current_user.notes
  end

  def show; end

  def new
    @note = current_user.notes.build
  end


  def create
    @note = current_user.notes.build(note_params)
    if @note.save
      redirect_to note_path(@note), notice: t('note.notice.create')
    else
      render :new
    end
  end

  def edit; end

  def update
    if @note.update(note_params)
      redirect_to note_path(@note), notice: t('note.notice.update')
    else
      render :edit
    end
  end

  def destroy
    @note.destroy
    redirect_to notes_path, notice: t('note.notice.delete')
  end

  private

  def set_note
    @note = current_user.notes.find(params[:id])
  end

  def note_params
    params.require(:note).permit(:title, :content)
  end
end
