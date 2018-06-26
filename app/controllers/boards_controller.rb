class BoardsController < ApplicationController

  skip_before_filter :verify_authenticity_token, only: [:add_filter, :edit_filter]

  def new
  end
  
  def create
    @board = Board.new(board_params)
    #@clean_widets = Array.new
    @board.widgets.reject! { |b| b.empty? }
    #@board.widgets = @clean_widgets
    @current_user ||= Users.find(session[:user_id]) if session[:user_id]
    @user_sources = Source.where(:user_id =>  @current_user.id).order(:provider)
    @board.userid = @current_user.id
    @board.save!
    redirect_to @board
  end
  
  def show
    p "========================boards_controller show====================="
    @current_user ||= Users.find(session[:user_id]) if session[:user_id]
    @board = Board.find(params[:id])
    @types_of_widgets = [['Email','email'],['Files','files'],['Contact','contact'],['Calendar','calendar'],['Notes','notes']]
    @filters = Filter.where(boardid: params[:id]).order("created_at ASC")
    p"=================filters : #{@filters}==============="
    if @board.userid.to_s == @current_user.id.to_s
      @widgets = Array.new
      @boards_list = @current_user.list_boards
      @board.widgets.each do |widget_id|
        @widgets.push(Widgets.find(widget_id))
      end
    else
      render :status => :forbidden, :text => "Forbidden fruit"
    end

  end
  
  def index
    @current_user ||= Users.find(session[:user_id]) if session[:user_id]
    @boards = Board.where(userid: @current_user.id)
  end

  def search
    @current_user ||= Users.find(session[:user_id]) if session[:user_id]
    puts "board parms: #{params}"
    @board = Board.find(params[:id])
    if @board.userid.to_s == @current_user.id.to_s
      @widgets = Array.new
      @boards_list = @current_user.list_boards
      @board.widgets.each do |widget_id|
        Widgets.find(widget_id).delay.search(params)
      end
    else
      render :status => :forbidden, :text => "Forbidden fruit"
    end
    redirect_to @board
  end

  def add_filter
    p "==================add_filter============"
    p "=========params : #{params}============"

    new_filter = Filter.new
    new_filter.filter = params[:filter_name]
    new_filter.widgetid = params[:widgetid]
    new_filter.boardid = params[:id]

    if new_filter.save
      data = {success:{filterid: new_filter.id, widgetid: new_filter.widgetid}}
    else
      data = {failure:{msg: new_filter.errors.full_messages.first}}
    end

    p "==============data : #{data}============="
    render json: data
  end

  def edit_filter
    p "=================edit_filter============"
    p "=================params : #{params}============"
    edit_filter = Filter.where(id: params[:filterid]).first;
    if edit_filter.nil?
      data = {failure: {msg: "Filter not found"}}
    else
      edit_filter.filter = params[:filter_name]
      if edit_filter.save
        data = {success:{msg: "Edit success!"}}
      else
        data = {failure:{msg: edit_filter.errors.full_messages.first}}
      end
    end

    render json: data
  end

  def del_filter
    p "=================del_filter============"
    p "=================params : #{params}============"
    Filter.where(filterid: params[:filterid]).destroy_all;
  end



  private
    def board_params
      params.require(:board).permit(:name, :widgets => [])
    end  
end
