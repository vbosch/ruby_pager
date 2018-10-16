class Algorithm_Line_Sorter
  attr_reader :sorted_lines, :sorted_index, :line_statistics
  def initialize(ex_region)
    @region=ex_region
    @sorted_order=Array.new
    @sorted_index=Hash.new
    @line_statistics=Hash.new
    @lateral_overlap = Array.new
    @vertical_overlap = Array.new
    @directly_above=Hash.new
    @directly_below=Hash.new
    run
  end

  private
  def run
    collect_line_statistics
    if @line_statistics.size > 0
      @sorted_order=@line_statistics.sort_by{|key,value| value[:avg_height]}.collect{|x| x[0]}
      @sorted_order.each_with_index {|value,index| @sorted_index[value]=index}
      calculate_possible_overlaps
      calculate_directly_above_line
      calculate_directly_below_line
      calculate_interline_space
    end
    @sorted_order.each{|line_id| puts "#{line_id} at #{sorted_index[line_id]} is below #{@directly_above[line_id]} is above #{@directly_below[line_id]}"}
    ap @lateral_overlap
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

  def calculate_possible_overlaps
     @sorted_order.combination(2).to_a.each do |pair|
       @lateral_overlap.push(pair) if lateral_overlap? *pair
       @vertical_overlap.push(pair) if vertical_overlap? *pair
     end
  end

  def lateral_overlap? (id1,id2)
    overlap_detected = false

    overlap_detected = true if @line_statistics[id1][:max_height] >= @line_statistics[id2][:max_height] and @line_statistics[id1][:max_height]<=@line_statistics[id2][:min_height]
    overlap_detected = true if @line_statistics[id2][:max_height] >= @line_statistics[id1][:max_height] and @line_statistics[id2][:max_height]<=@line_statistics[id1][:min_height]
    overlap_detected = true if @line_statistics[id1][:min_height] >= @line_statistics[id2][:max_height] and @line_statistics[id1][:min_height]<=line_statistics[id2][:min_height]
    overlap_detected = true if @line_statistics[id2][:min_height] >= @line_statistics[id1][:max_height] and @line_statistics[id2][:min_height]<=line_statistics[id1][:min_height]

    return overlap_detected
  end

  def vertical_overlap? (id1,id2)
    overlap_detected = false

    overlap_detected = true if @line_statistics[id1][:max_width] <= @line_statistics[id2][:max_width] and @line_statistics[id1][:max_width]>=@line_statistics[id2][:min_width]
    overlap_detected = true if @line_statistics[id2][:max_width] <= @line_statistics[id1][:max_width] and @line_statistics[id2][:max_width]>=@line_statistics[id1][:min_width]
    overlap_detected = true if @line_statistics[id1][:min_width] <= @line_statistics[id2][:max_width] and @line_statistics[id1][:min_width]>=line_statistics[id2][:min_width]
    overlap_detected = true if @line_statistics[id2][:min_width] <= @line_statistics[id1][:max_width] and @line_statistics[id2][:min_width]>=line_statistics[id1][:min_width]

    return overlap_detected
  end

  def calculate_directly_above_line
    @sorted_order.each do |line_id|
     possible= @vertical_overlap.select{ |pair| pair if (pair[0]==line_id and is_above?(pair[0],pair[1]))or (pair[1]==line_id and is_above?(pair[1],pair[0]))}
     @directly_above[line_id] = closest_above(line_id,possible)
     @directly_below[@directly_above[line_id]]=line_id if @directly_below[@directly_above[line_id]]==nil
    end
  end

  def calculate_directly_below_line
    @sorted_order.each do |line_id|
      possible= @vertical_overlap.select{ |pair| pair if (pair[0]==line_id and is_above?(pair[1],pair[0]))or (pair[1]==line_id and is_above?(pair[0],pair[1]))}
      @directly_below[line_id] = closest_below(line_id,possible)
    end
  end

  def closest_above(line_id,possible)
    closest = line_id
    possible.each do |pair|
      candidate = pair[0]==line_id ? pair[1] : pair[0]
      if closest == line_id
        closest = candidate
      else
        closest = is_above?(candidate,closest) ? candidate : closest
      end
    end
    return closest
  end

  def closest_below(line_id,possible)
    closest = line_id
    possible.each do |pair|
      candidate = pair[0]==line_id ? pair[1] : pair[0]
      if closest == line_id
        closest = candidate
      else
        closest = is_above?(candidate,closest) ? closest : candidate
      end
    end
    return closest
  end

  def is_above?(id_lower, id_higher)
    return @sorted_index[id_lower] > @sorted_index[id_higher]
  end

  def calculate_interline_space
    @sorted_order.each do |line_id|
      @directly_above[line_id]
    end
  end
 end