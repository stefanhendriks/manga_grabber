require 'open-uri'
require 'nokogiri'

class MangaGrabber


	def initialize
		@base_url = "http://www.manga-access.com/manga/N/Naruto/chapter"
	end

	def fetch_chapter(chapter)
		(1..30).each do |page|
			begin
				fetch_chapter_page(chapter, page)
			rescue (error)
				puts "an error occured, assuming page #{page} was last page."
				break
			end
		end
		puts "Done fetching chapter #{chapter}."
	end

	def fetch_chapter_page(chapter, page)
		complete_url = "#{@base_url}/#{chapter}/#{page}"
		puts "Grabbing manga Naruto chapter #{chapter}, page #{page} from [#{complete_url}]"
		html = open(complete_url)
		doc = Nokogiri::HTML(html)
		doc.search('#pic').each do |element|
			filename = ""
			filename += "0" if page < 10
			filename += "#{page}_#{chapter}_page.png"
			open("manga/#{filename}.png", 'wb') do |file|
				url_pic = element['rel']
				file << open(url_pic).read
			end

		end
	end


end

mg = MangaGrabber.new
mg.fetch_chapter(301)
