class Board < ActiveRecord::Base
  serialize :widgets, Array

  def auto_setup(current_user)
    puts "*********** AUTO SETUP ********"
    self.name = "Default"
    #@board.widgets = @clean_widgets
    source = Source.where(:user_id => current_user.id).first
    self.userid = current_user.id
    case source.provider
    when "google"
      #files
      widget = Widgets.new(name: "Files", userid: current_user.id, sources: [source.id], widget_type: "files")
      widget.save!
      self.widgets = [widget.id]
      #email
      widget = Widgets.new(name: "Email", userid: current_user.id, sources: [source.id], widget_type: "email")
      widget.save!
      self.widgets << widget.id
      #calendar
      widget = Widgets.new(name: "Calendar", userid: current_user.id, sources: [source.id], widget_type: "calendar")
      widget.save!
      self.widgets << widget.id
      #contacts
      #widget = Widgets.new(name: "Contacts", userid: current_user.id, sources: [source.id], widget_type: "contact")
      #widget.save!
      #self.widgets << widget.id
    when "evernote"
      #notes
      widget = Widgets.new(name: "Notes", userid: current_user.id, sources: [source.id], widget_type: "notes")
      widget.save!
      self.widgets << widget.id
    else
    end
    self.save!
  end
  
  def add_widget(widget)
    self.widgets << widget.id
    self.save!
  end
end

