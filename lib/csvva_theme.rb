class CsvvaTheme < Scruffy::Themes::Base
  def initialize
    super({
            :background => nil,
            :marker => :black,
            :colors => %w(#CC9933 #FFCC66 #CCCC99 #CCCC33 #99CC33 #3333CC #336699 #6633CC #9999CC #333366)
          })
  end
end
