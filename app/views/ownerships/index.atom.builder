atom_feed do |feed|
  feed.title "#{@username}'s events"
  feed.updated(@events.empty? ? Time.now : @events.first.created_at)

  @events.each do |event|
    feed.entry(event, :url => ownership_path(@username, event.book.isbn)) do |entry|
      entry.title "#{event.book.title} (#{event.description})"
      entry.content show_book(event.book), :type => 'html'
      entry.author { |author| author.name event.user.username }
    end
  end
end
