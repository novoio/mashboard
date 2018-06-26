module Sigfigtime
  def sig_fig_time(datetime)  #need to move this 
    since_mod_full = Time.diff(Time.parse(datetime), Time.now)
    if since_mod_full[:year] > 1
      result = "Over a year ago"
    elsif since_mod_full[:year] > 0
      result = "1 year ago"
    elsif since_mod_full[:month] > 1
      result = "#{since_mod_full[:month]} months ago"
    elsif since_mod_full[:month] > 0
      result = "#{since_mod_full[:month]} month ago"
    elsif since_mod_full[:day] > 1
      result = "#{since_mod_full[:day]} days ago"
    elsif since_mod_full[:day] > 0
      result = "#{since_mod_full[:day]} day ago"
    elsif since_mod_full[:hour] > 1
      result = "#{since_mod_full[:hour]} hours ago"
    elsif since_mod_full[:hour] > 0
      result = "#{since_mod_full[:hour]} hour ago"
    elsif since_mod_full[:minute] > 1
      result = "#{since_mod_full[:minute]} minutes ago"
    elsif since_mod_full[:minute] > 0
      result = "#{since_mod_full[:minute]} minute ago"
    else
      result = "Less than a minute ago"
    end
    return result
  end
end