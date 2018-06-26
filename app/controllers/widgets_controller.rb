class WidgetsController < ApplicationController
  def new
    @current_user ||= Users.find(session[:user_id]) if session[:user_id]
    @sources = Source.where(:user_id => @current_user.id)
  end
  
  def create
    @current_user ||= Users.find(session[:user_id]) if session[:user_id]
    @widget = Widgets.new
    @widget.name = widget_params[:name]
    @widget.widget_type = widget_params[:widget_type]
    @widget.sources = [widget_params[:source].to_i]
    @current_user ||= Users.find(session[:user_id]) if session[:user_id]
    @widget.userid = @current_user.id
    @widget.save!
    @board = Board.find(params[:board].to_i)
    if Board.exists?(@board)
      @board.add_widget(@widget)
      redirect_to @board
    else
      redirect_to Board.where(userid: @current_user.id).first
    end
  end
  
  def index
    @current_user ||= Users.find(session[:user_id]) if session[:user_id]
    @widgets = Widgets.where(:userid => @current_user.id.to_s)
  end
  
  def show
    @widget = Widgets.find(params[:id])
    # @filters = @widget.applied_filters
    @filters = @widget.applied_filters.map(&:filter)

    @current_user ||= Users.find(session[:user_id]) if session[:user_id]
    #@user_sources = Source.where(:user_id => @current_user.id).order(:provider)
    @items = @widget.list_items
    @filteredItems = [];

    if @filters.count > 0
      regex = /#{@filters.map(&:downcase).join("|")}/
      @items.each do |item|
        if @widget.widget_type == 'files'
          contentStr = item[:name]
        elsif @widget.widget_type == 'email'
          contentStr = "#{item[:sender]} #{item[:sender_email]} #{item[:subject]}"
        elsif @widget.widget_type == 'calendar'
          contentStr = "#{item[:title]} #{item[:creator]}"
        elsif @widget.widget_type == 'note'
          contentStr = item[:name]
        end

        contentStr = contentStr.downcase
        if !regex.match(contentStr).nil?
          @filteredItems.push(item)
        end
      end
    else
      @filteredItems = @items
    end

    if params.has_key?(:search) && params[:search]=="true"
      #need to load more data with search
    elsif params.has_key?(:page)
      #need to load more data default method
      # @items = @widget.list_items
      @filteredItems = @filteredItems.paginate(:page => params[:page], :per_page => 10)
    else
      # @items = @widget.list_items
      @filteredItems = @filteredItems.paginate(:page => "1", :per_page => 10)  
    end

    respond_to do |format|
      format.html # show.html.erb
      p "=================respond_to===================="
      format.json { render :json => {:id => @widget.id,  :name => @widget.name, :widget_type => @widget.widget_type, :sources => @widget.sources, :userid => @widget.userid, :items => @filteredItems, :filters => @widget.filters} }
    end
  end
  
  def update
    @current_user ||= Users.find(session[:user_id]) if session[:user_id]
    @widget = Widgets.find(params[:id])
    if params.has_key?(:sources)
      @widget.sources << params[:sources].to_i
      @widget.save
    end
    if params.has_key?(:delete) && params[:delete]=="true"
      @current_user.remove_widget(@widget)
    end
    if params.has_key?(:delete_source)
      @widget.sources.delete(params[:delete_source])
      @widget.save
    end
    redirect_to Board.where(userid: @current_user.id).first
  end

  def dropbox_download
    @current_user ||= Users.find(session[:user_id]) if session[:user_id]
    puts "widgets:dropbox_download parms: #{params}"
    if @current_user.id.to_s
      @widget = Widgets.where(:userid => @current_user.id.to_s).first
      url = @widget.dropbox_download(params)
      redirect_to url
    end
  end

  private
    def widget_params
      params.require(:widget).permit(:name, :widget_type, :source, :board)
    end
  
end
