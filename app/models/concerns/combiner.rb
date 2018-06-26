module Combiner
  def combine_files(result, new_items, source)
    cur_time = Time.now.strftime('%Y-%m-%d %H:%M')
    case source.provider
    when "google"
      new_items.each do |item|
        modified_time = DateTime.parse(item.modifiedDate.to_s).to_s(:number)
        temp = { :name => item.title, :size => item['fileSize'], :updated => modified_time, :link => item['alternateLink'], :icon => "icon gdrive", :since =>sig_fig_time(modified_time), :is_dir => FALSE}
        if result.blank?
          result = [temp]
        else
          result << temp
        end
      end
    when "dropbox"
      new_items.each do |item|
        modified_time = DateTime.parse(item.modified.to_s).to_s(:number)
        if item.is_dir
          temp = { :name => item.path, :size => item.bytes, :updated => modified_time, :link => "is_dir", :icon => "icon dropbox", :since =>sig_fig_time(modified_time), :is_dir => TRUE}
        else
          temp = { :name => item.path, :size => item.bytes, :updated => modified_time, :link => "/dropbox_download/#{source.id}/#{item.path}", :icon => "icon dropbox", :since =>sig_fig_time(modified_time), :is_dir => FALSE}
        end
        if result.blank?
          result = [temp]
        else
          result << temp
        end
      end
    else
    end
    if !result.nil?
      return result.sort_by { |i| i[:updated] }.reverse!
    else
      return result
    end
  end
end