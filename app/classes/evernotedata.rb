class Evernotedata
  attr_accessor :oauth_token, :oauth_secret
  
  def initialize(token, secret)
    self.oauth_token = token
    self.oauth_secret = secret
  end

## From test harness .. Can't work through code until Nick's work is done.
  def client
    @client ||= EvernoteOAuth::Client.new(token: auth_token, consumer_key:OAUTH_CONSUMER_KEY, consumer_secret:OAUTH_CONSUMER_SECRET, sandbox: SANDBOX)
  end

  def user_store
    @user_store ||= client.user_store
  end

  def note_store
    @note_store ||= client.note_store
  end

  def en_user
    user_store.getUser(auth_token)
  end

  def notebooks
    @notebooks ||= note_store.listNotebooks(auth_token)
  end


  def pull
    puts "**************** Evernote Pull"
    filter = Evernote::EDAM::NoteStore::NoteFilter.new
    # Get all the notes for a notebook
    notes = note_store.findNotes(auth_token, filter, nil, 10) 
    puts "Notes: #{notes.inspect}"
    # Display the notes
    notes.notes.each do |note|
      puts "***********************"
      puts note.title
      puts note.guid
      puts note.attributes.inspect
      content = note_store.getNoteContent(auth_token, note.guid)
      puts content.inspect
      puts "<<<<<<<<<<<<<<<<<<<<<<<"
    end
    results = []
    return results
  end

  def search(searchText)
    puts "**************** Evernote Search"
    puts "Searching >>> "
    filter = Evernote::EDAM::NoteStore::NoteFilter.new
    filter.words = keywords

    spec = Evernote::EDAM::NoteStore::NotesMetadataResultSpec.new
    spec.includeTitle = true

    # Get all the notes for a notebook
    notes = note_store.findNotesMetadata(auth_token, filter, nil, 10, spec) 
    puts "Notes: #{notes.inspect}"
    # Display the notes
    notes.notes.each do |note|
      puts ">>>>>>>>>>>>>>"
      puts note.title
      puts note.guid
      puts note.attributes.inspect
      content = note_store.getNoteContent(auth_token, note.guid)
      puts content.inspect
      puts "<<<<<<<<<<<<<<<<<<<<<<<"
    end
    results = []
    return results
  end
end