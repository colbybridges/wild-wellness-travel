class RetreatsController < ApplicationController
  skip_before_action :authenticate_user!, only: [:index, :show]

  def index
    @retreats = Retreat.where(active: true)
  end

  def show
    @retreat = Retreat.find(params[:id])
    @property = @retreat.property
    @booking = Booking.new
  end

  def new
    @retreat = Retreat.new
  end

  def create
    @retreat = Retreat.new(retreat_params.except(:retreat_leaders))
    if @retreat.save
      # assign retreat ids to leaders
      retreat_params[:retreat_leaders].each do |r|
        RetreatLeader.find(r).update(retreat_id: @retreat.id) unless r.empty?
      end
      redirect_to edit_retreat_path(@retreat)
    else
      render 'new'
    end
  end

  def edit
    @retreat = Retreat.find(params[:id])
    @property = @retreat.property
  end

  def update
    @retreat = Retreat.find(params[:id])
    if @retreat.update(retreat_params.except(:retreat_leaders))
      # clear leader retreat ids
      RetreatLeader.where(retreat_id: params[:id]).map{ |r| r.update(retreat_id: nil) }
      # re-assign retreat ids to leaders
      retreat_params[:retreat_leaders].each do |r|
        RetreatLeader.find(r).update(retreat_id: @retreat.id) unless r.empty?
      end
      redirect_to edit_retreat_path
    else
      render 'edit'
    end
  end

  def destroy
    @retreat = Retreat.find(params[:id])
    @retreat.destroy
    redirect_to root_path
  end

  def retreat_params
    params.require(:retreat).permit(:name, :property_id, :start_date, :end_date, :phone_number,
      :email, :available_spots, :video, :price, :description, :retreat_leaders => [])
  end
end
