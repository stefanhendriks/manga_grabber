require 'open-uri'
require 'nokogiri'

class MangaGrabber

	def initialize
		@base_url = "http://www.manga-access.com/manga/N/Naruto/chapter"
		@manga_title = "Naruto"
		make_sure_manga_dir_exists
	end

	def fetch_chapter(chapter)
		make_sure_chapter_dir_exists chapter
		puts "Grabbing manga Naruto chapter #{chapter}..."
		(1..99).each do |page| #99 is an magic number, assuming no chapter exists with more than 99 pages
			begin
				fetch_chapter_page(chapter, page)
			rescue
				puts "An error occured. Assuming that page #{page} was the last page of chapter #{chapter}"
				break
			end
		end
	end

	def manga_dir
		"manga/#{@manga_title}"
	end

	def make_sure_manga_dir_exists
		Dir.mkdir(manga_dir) unless File.exists?(manga_dir)
	end

	def manga_chapter_dir(chapter)
		chptr = ""
		chptr += "0" if chapter < 10
		chptr += "0" if chapter < 100
		chptr += chapter.to_s
		"#{manga_dir}/#{chptr}"
	end

	def make_sure_chapter_dir_exists(chapter)
		dir = manga_chapter_dir(chapter)
		Dir.mkdir(dir) unless File.exists?(dir)
	end

	def fetch_chapter_page(chapter, page)
		complete_url = "#{@base_url}/#{chapter}/#{page}"
		filename = "#{manga_chapter_dir(chapter)}/#{make_filename(page)}"
		print "."
		#puts "Grabbing manga Naruto chapter #{chapter}, page #{page} from [#{complete_url}]... saving to --> #{filename}"
		
		if File.exists?(filename)
			puts "File [#{filename}] already exists. Will not fetch new page."
			return
		end

		html = open(complete_url)
		doc = Nokogiri::HTML(html)
		doc.search('#pic img').each do |element|
			url_pic = element['src']
		#	puts "Grabbing picture from #{url_pic}"
			stream = open(url_pic)
			open(filename, 'wb') do |file|
				file << stream.read
			end
		end
	end

	def make_filename(page)
		filename = ""
		filename += "0" if page < 10
		filename += "#{page}.png"
		filename
	end

end

mg = MangaGrabber.new
(1..615).each do |chapter|
	mg.fetch_chapter(chapter)
end
