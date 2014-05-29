class YogurtsController < ApplicationController
  before_action :set_yogurt, :only => [:show, :edit, :update, :destroy]
  respond_to :json

  def index
    @yogurts = Yogurt.all
    respond_with @yogurts
  end

  def show
    respond_with @yogurt
  end

  def create
    @yogurt = Yogurt.new(yogurt_params)

    if @yogurt.save
      render json: @yogurt, status: :created
    else
      render json: @yogurt.errors, status: :unprocessable_entity
    end
  end

  def update

    if @yogurt.update(yogurt_params)
      render nothing: true, status: 204
    else
      render json: @yogurt.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @yogurt.destroy
    render json: :no_content
  end

  protected

  def set_yogurt
    @yogurt = Yogurt.find(params[:id])
  end

  def yogurt_params
    params.require(:yogurt).permit(:flavor, :topping, :quantity)
  end

end