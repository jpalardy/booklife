class Book < ActiveRecord::Base
  has_many :ownerships
  has_many :users, :through => :ownerships
  has_many :events

  validates_presence_of :title, :authors, :isbn, :image_url, :published_on, :pages
  validates_uniqueness_of :isbn

  acts_as_ferret :fields => [:title, :authors, :isbn]

  ############################################################

  module Amazon
    def self.logger
      parent.logger
    end

    def self.find_all(query)
      results = Cache::get("query-#{query.gsub(/ /, '_')}") do
                  logger.info "**** Amazon query: '#{query}'"
                  ::Amazon::Ecs.item_search(query, :response_group => 'Medium', :sort => 'salesrank')
                end

      results.items.collect do |result|
        next unless result.get('isbn') && result.get_hash('mediumimage')

        book = Book.new        :title => result.get('title'),
                             :authors => result.get_array('author').join(', '),
                                :isbn => result.get('isbn'),
                               :pages => result.get('numberofpages').to_i,
                        :published_on => result.get('publicationdate'),
                           :image_url => result.get_hash('mediumimage')[:url],
                         :image_width => result.get_hash('mediumimage')[:width],
                        :image_height => result.get_hash('mediumimage')[:height]

        book.authors = '-' if book.authors.blank?

        Cache::add("book-#{book.isbn}", book, 30.minutes)
        book
      end.compact
    end

    def self.find_by_isbn(isbn)
      Cache::get("book-#{isbn}") do
        find_all(isbn).find {|book| book.isbn == isbn}
      end
    end
  end

  ############################################################

end
