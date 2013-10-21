class TreeParser

  attr_reader :tree, :template_array

  def initialize(file)
    @tree = lines_to_array(file)
    @template_array = []
  end

  def lines_to_array(file)
    File.read(file).each_line.map do |line|
      line.chomp
    end.reject {|l| l == ""}
  end

  def build_template_array
    top_level_dir = ""
    mid_level_dirs = []
    self.tree.each_with_index do |dir, i|
      top_level_dir = dir.gsub(/\W/,"") if dir.start_with?("├") || dir.start_with?("└")
      if dir.gsub(/\W/,"") == top_level_dir
        mid_level_dirs = []
        self.template_array << dir.gsub(/\W/,"")
      else
        if self.tree[i-1].count(' ') == self.tree[i].count(' ') || self.tree[i-1].gsub(/\W/,"") == top_level_dir
          path_string = "#{top_level_dir}/#{dir.gsub(/\W/,'')}"
          mid_level_dirs << dir.gsub(/\W/,"")
        elsif self.tree[i-1].index(/\w/) > self.tree[i].index(/\w/)
          mid_level_dirs = []
          path_string = "#{top_level_dir}/#{dir.gsub(/\W/,'')}"
          mid_level_dirs << dir.gsub(/\W/,"")
        else
          path_string = "#{top_level_dir}/#{mid_level_dirs.join('/')}/#{dir.gsub(/\W/,'')}"
          mid_level_dirs << dir.gsub(/\W/,"")
        end 
        self.template_array << path_string
      end
    end
    puts self.template_array.inspect
  end

end

t = TreeParser.new('sample-tree-2.txt')
t.build_template_array