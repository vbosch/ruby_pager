class Algorithm_Line_Sorter
  attr_reader :sorted_lines, :sorted_index, :line_statistics
  def initialize(ex_region)
    @region=ex_region
    @sorted_order=Array.new
    @sorted_index=Hash.new
    @line_statistics=Hash.new
    run
  end

  private
  def run
    collect_line_statistics
    if @line_statistics.size > 0
      puts "collisions?"
      calculate_possible_collisions
    end
  end

  def collect_line_statistics
    @region.each do |id,line|
      @line_statistics[id]=Hash.new
      @line_statistics[id][:max_height]=line.baseline.max_height
      @line_statistics[id][:min_height]=line.baseline.min_height
      @line_statistics[id][:avg_height]=line.baseline.avg_height
      @line_statistics[id][:max_width]=line.baseline.max_width
      @line_statistics[id][:min_width]=line.baseline.min_width
    end
  end

  def calculate_possible_collisions

  end

end