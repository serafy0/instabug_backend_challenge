class AppsController < ApplicationController
  before_action :set_app, only: %i[show update destroy]

  # GET /apps
  def index
    @apps = App.select(:token, :name, :chats_count).as_json(except: :id)

    render json: @apps
  end

  # GET /apps/[app_token]
  def show
    render json: @app.as_json(except: :id)
  end

  # POST /apps
  def create
    @app = App.new(app_params)
    if @app.save
      render json: @app.as_json(except: :id), status: :created, location: @app
    else
      render json: @app.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /apps/[app_token]
  def update
    if @app.update(app_params).as_json(except: :id)
      render json: @app
    else
      render json: @app.errors, status: :unprocessable_entity
    end
  end

  # DELETE /apps/[app_token]
  def destroy
    @app.destroy
  end

  private

  def set_app
    token = params[:id]

    @app = App.find_by token: token
  end

  def app_params
    params.require(:app).permit(:name).with_defaults(chats_count: 0)
  end
end
