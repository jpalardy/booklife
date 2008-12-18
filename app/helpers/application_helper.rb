# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def cover_link(book)
    link_to_unless_current image_tag(book.image_url, :width => book.image_width, :height => book.image_height, :title => book.title), ownership_path(@username || myself, book.isbn)
  end

  def show_book(book, mode='list')
    render :partial => "books/book.html.erb", :locals => {:book => book, :mode => mode}
  end

  def show_books(books, mode)
    books.collect {|book| show_book(book, mode)}
  end

  ############################################################

  def nav_links
    links = []

    if logged_in?
      links << [link_to("#{myself}'s", ownerships_path(myself)), {:class => selected?(@username == myself)}]
      links << [link_to("amazon's", amazon_path), {:class => selected?(controller_name == 'amazon')}]
      if controller_name == 'ownerships' && @username != myself
        links << [link_to("#{@username}'s", ownerships_path(@username)), {:class => selected?(true)}]
      end
    else
      links << [link_to("#{@username}'s", ownerships_path(@username)), {:class => selected?(controller_name == 'ownerships')}] if @username
    end

    make_ul(links)
  end

  ############################################################

  def sidebar_links(selected)
    result = Status.all.unshift('all').collect do |status|
      [link_to(status, ownerships_path(@username, :status => status)), {:class => selected?(status == selected)}]
    end

    make_ul(result)
  end

  ############################################################

  def mode_button(name, mode)
    pressed = mode == name
    link_to_unless pressed, image_tag("#{name}_#{pressed ? 'on' : 'off'}.gif", :width => 26, :height => 24), url_for_mode(name, true)
  end

  def url_for_mode(mode, escape)
    url_for request.parameters.merge(:mode => mode, :escape => escape)
  end

  ############################################################

  def back_url_or(default)
    request.env['HTTP_REFERER'] || default
  end

  def login_logout_link
    if logged_in?
      content_tag :div, :class => 'login_logout' do
        [session[:username], ' | ', link_to('logout', logout_path)]
      end
    else
      content_tag :div, :class => 'login_logout' do
        [link_to('register', register_path), ' | ', link_to('login', login_path)]
      end
    end
  end

  def selected?(cond)
    cond ? 'selected' : nil
  end

  ############################################################

  def booklife_bookmarklet
    "javascript:location='#{ownerships_url(myself)}/'+document.URL.match(/[0-9]{9}[0-9X]/)"
  end

  def amazon_search_link(query)
    'http://www.amazon.com/s/?url=search-alias%3Dstripbooks&field-keywords=' + query
  end

  ############################################################

  def show_grouped(ownerships, mode)
    grouped = ownerships.group_by(&:status)

    render :partial => 'grouped', :locals => {:grouped => grouped, :mode => mode}
  end

  ############################################################

  def messages(*args)
    msgs, options = args.last.class == Hash ? [args[0..-2], args.last] : [args, {}]

    content_tag :div, {:class => 'message'}.merge(options) do
      make_ul(msgs)
    end
  end

  def make_ul(content_options, options={})
    content_tag :ul, options do
      content_options.collect do |content, options|
        content_tag :li, content, options
      end
    end
  end

  def title(text)
    content_for :title, ': ' + text
  end

end
