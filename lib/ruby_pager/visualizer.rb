
require "gosu"


class Visualizer < Gosu::Window

  def initialize(ex_width=640,ex_height=480,ex_full=false)
    super ex_width,ex_height, :fullscreen => ex_full
    #@sidebar = Side_Bar.new { |example| change_example(example) }
    self.caption = "Ruby Pager Visualizer"
  end

  def needs_cursor?
    true
  end

  def update

  end

  def draw

  end



end