module IMDB
  # Get movie information with IMDB movie id.
  # @example Get Yahsi Bati movie title and cast listing [http://www.imdb.com/title/tt1567448/]
  #   m = IMDB::Movie.new('1567448')
  #   puts m.title
  class Movie < IMDB::Skeleton
    attr_accessor :link, :imdb_id

    def initialize(id_of)
      # !!!DON'T FORGET DEFINE NEW METHODS IN SUPER!!!
      super("Movie", { :imdb_id => String,
                       :poster => String,
                       :title => String,
                       :release_date => String,
                       :cast => Array,
                       :photos => Array,
                       :director => String,
                       :director_person => Person,
                       :genres => Array,
                       :rating => Float,
                       :movielength => Integer,
                       :short_description => String,
                       :writers => Array }, [:imdb_id])

      @imdb_id = id_of

      @link = "http://www.imdb.com/title/tt#{@imdb_id}"
    end

    # Get movie poster address
    # @return [String]
    def poster
      src = doc.at("#img_primary img")["src"] rescue nil
      unless src.nil?
        if src.match(/\._V1/)
          return src.match(/(.*)\._V1.*(.jpg)/)[1, 2].join
        else
          return src
        end
      end
      src
    end

    # Get movie title
    # @return [String]
    def title
      doc.at("//head/meta[@name='title']")["content"].split(/\(\d+\)/)[0].strip! ||
          doc.at("h1.header").children.first.text.strip

    end

    # Get movie cast listing
    # @return [Cast[]]
    def cast
      doc.search("table.cast tr").map do |link|
        #picture = link.children[0].search("img")[0]["src"] rescue nil
        #name = link.children[1].content.strip rescue nil
        id = link.children[1].search('a[@href^="/name/nm"]').first["href"].match(/\/name\/nm([0-9]+)/)[1] rescue nil
        char = link.children[3].content.strip rescue nil
        unless id.nil?
          person = IMDB::Person.new(id)
          IMDB::Cast.new(self, person, char)
        end
      end.compact
    end

    # Get movie photos
    # @return [Array]
    def photos
      begin
        doc.search('#main .thumb_list img').map { |i| i["src"] }
      rescue
        nil
      end
    end

    # Get release date
    # @return [String]
    def release_date
      if (node = doc.xpath("//h4[contains(., 'Release Date')]/..")).length > 0
        date = node.search("time").first["datetime"]
        if date.match /^\d{4}$/
          "#{date}-01-01"
        else
          Date.parse(date).to_s
        end
      else
        year = doc.at("h1.header .nobr").text[/\d{4}/]
        "#{year}-01-01"
      end
    rescue
      nil
    end

    # Get Director
    # @return [String]
    def director
      self.director_person.name rescue nil
    end

    # Get Director Person class
    # @return [Person]
    def director_person
      begin
        link=doc.xpath("//h4[contains(., 'Director')]/..").at('a[@href^="/name/nm"]')
        profile = link['href'].match(/\/name\/nm([0-9]+)/)[1] rescue nil
        IMDB::Person.new(profile) unless profile.nil?
      rescue
        nil
      end
    end

    # Genre List
    # @return [Array]
    def genres
      doc.xpath("//h4[contains(., 'Genre')]/..").search("a").map { |g|
        g.content unless g.content =~ /See more/
      }.compact
    rescue
      nil
    end

    # Writer List
    # @return [Float]
    def rating
      @rating ||= doc.search(".star-box-giga-star").text.strip.to_f
    rescue
      nil
    end

    #Get the movielength of the movie in minutes
    # @return [Integer]
    def movielength
      doc.at("//h4[text()='Runtime:']/..").inner_html[/\d+ min/].to_i rescue nil
    end

    # Writer List
    # @return [Array]
    def writers
      doc.xpath("//a[@name='writers']/../../../..").search('a[@href^="/name/nm"]').map { |w|
        profile = w['href'].match(/\/name\/nm([0-9]+)/)[1] rescue nil
        IMDB::Person.new(profile) unless profile.nil?
      }
    end

    # @return [String]
    def short_description
      doc.at("#overview-top p[itemprop=description]").text.strip
    end

    private

    def doc
      if caller[0] =~ /`([^']*)'/ and ($1 == "cast" or $1 == "writers")
        @doc_full ||= Nokogiri::HTML(open("#{@link}/fullcredits"))
      elsif caller[0] =~ /`([^']*)'/ and ($1 == "photos")
        @doc_photo ||= Nokogiri::HTML(open("#{@link}/mediaindex"))
      else
        @doc ||= Nokogiri::HTML(open("#{@link}"))
      end
    end

  end # Movie
end # IMDB

