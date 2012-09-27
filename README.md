Welcome to Ruby IMDB
--------------------

ruby-imdb is IMDB parsing library for Ruby.
it's an upgrade from this gem: http://github.com/yalcin/ruby-imdb

Features
--------

- Dynamic Caching with MongoDB backend
- Object Oriented design
- Fast access to data

Download
--------

- [sudo] gem i imdb-scan
- http://github.com/oniram88/imdb-scan
- git clone git://github.com/oniram88/imdb-scan.git



Usage
-----
    require 'rubygems'
    require 'imdb'

    s = IMDB::Search.new
    s.movie("fear and loathing in las vegas").each do
      |result|
      movie = IMDB::Movie.new(result.id)
      p movie.title
      movie.cast.each do
        |cast|
        p "#{cast.name} as #{cast.char}"
      end
      p movie.poster
    end

    movie = IMDB::Movie.new('0120669')
    p movie.poster

Examples
--------

Are Under features directory

Authors
-------
- Yalcin ACIKYILDIZ (mailto:yalcin@webliyacelebi.com)


This library is released under the terms of the GNU/GPL.

