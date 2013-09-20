def remove_dash_from_links(text)
  matches = text.scan(/\[\[([^\]]+)\]\]/)
  matches.each do |m|
    text.gsub!(m.first, m.first.gsub("-", " "))
  end
  text
end

Dir.new(".").grep(/[A-Z]/).each do |f|
  title = f.gsub("-"," ").gsub("\.md","")

  old_text = File.open(f).read().to_s

  new_text = "#{title}\n==\n\n#{remove_dash_from_links(old_text)}\n\n"
  File.open(f,'w').write(new_text)
end


