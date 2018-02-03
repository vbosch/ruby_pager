require 'ap'
#require 'ruby-debug'

require_relative '../lib/application_logger'


module Utils
  class Histogram
	def initialize(file_path,ex_type)
      @logger = Utils::ApplicationLogger.instance
      @logger.level = Logger::INFO
	  @limits= []
	  @type = ex_type.to_sym
	  @histogram= Hash.new{|h,key|h[key]=Array.new}
	  @derivate= Hash.new{|h,key|h[key]=Array.new}
      @logger.info("Loading histogram")
	  load_file(file_path)
	end

	def load_file(file_path)
		
		File.open(file_path, "r") do |file|
			while (line = file.gets)
				process_line(line)	
			end
		end
		puts "BUCKETS ARE  #{@buckets}"
		puts "HISTOGRAMS ARE #{@histogram.size}"
		puts "HISTOGRAMS ARE #{@histogram[0].size}"
	end

	def process_line(line)
		
		values = line.split
		@buckets = values[1].to_i if values[0] == "NumVect"
		
		if values[0]== "NumParam"
			@num_histograms = values[1].to_i
			@num_histograms/=2 if @type == :derivate
		end
		
		process_limit(values[1..2].map{|val| val.to_i}) if values[0] == "Limit"
      	@logger.info("Processing data") if values[0] == "Data"

		process_data_line(values.map{|val| val.to_f})if values[0] =~ /\d/  
		
	end

	def process_limit(values)
	
		@limits.push({:start => values[0],:end => values[1]})	
	end
	
	def process_data_line(values)
		if @type == :basic
			values.each_index{|i| @histogram[i].push(values[i])}
		else
			values.each_index do |i|
				if i.even?
					@histogram[i/2].push(values[i])
				else
					@derivate[(i-1)/2].push(values[i])	
				end
			end

		end
	end

	def to_line(hist_index,row_index)
#return [@limits[hist_index][:start],((@limits[hist_index][:end] - @limits[hist_index][:start])*@histogram[hist_index][row_index]*100).to_i+ @limits[hist_index][:start]]
	    
		return [@limits[hist_index][:start],((@limits[hist_index][:end] - @limits[hist_index][:start])*(@histogram[hist_index][row_index])/100).to_i+ @limits[hist_index][:start]] if hist_index < 3
	   return [@limits[hist_index][:start],((@limits[hist_index][:end] - @limits[hist_index][:start])*@histogram[hist_index][row_index]*200).to_i+ @limits[hist_index][:start]] if hist_index == 3
	   return [@limits[hist_index][:start],((@limits[hist_index][:end] - @limits[hist_index][:start])*@histogram[hist_index][row_index]*2000).to_i+ @limits[hist_index][:start]] if hist_index > 3

	end


	def derivate_to_line(hist_index,row_index)
		return [@limits[hist_index][:start],((@limits[hist_index][:end] - @limits[hist_index][:start])*@derivate[hist_index][row_index]*2000).to_i+ @limits[hist_index][:start]]
	end

	def each_line
		@buckets.times do |r|
			temp = []
			@num_histograms.times do |h|
				temp.push(to_line(h,r))
			end
			yield r,temp
		end
	end

	def each_derivate
		@buckets.times do |r|
			temp = []
			@num_histograms.times do |h|
				temp.push(derivate_to_line(h,r))
			end
			yield r,temp
		end
	end
  end
end

