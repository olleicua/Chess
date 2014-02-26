require 'game'

class UI
  def initialize
    @b = Game.new
    @b.print
    @moves = []
  end
  
  def run
    while true
      print '> '
      STDOUT.flush
      command = gets.chomp
      command.split(';').each do |cmd|
        case cmd
        when 'moves' then moves
        when /^a ?([wb]) ?([rnbqkp]) ?([a-h][1-8])$/i
          add $1, $2, $3
        when /^r ?([a-h][1-8])$/
          @b.pop($1)
        when /^m ?([a-h][1-8]) ?([a-h][1-8])$/
          move $1, $2
        when 'u' then unmove
        when 's' then solve.each{|m| puts m}
        when 't' then @b.toggle_turn
        when 'd' then binding.pry
        when 'quit' then exit
        else next
        end
      end
      @b.print
    end
  end
  
  def count_after m
    @b.after_move(m){@b.moves.size}
  end
  
  def moves
    @b.moves.each do |m|
      puts "#{m}: #{count_after m}"
    end
  end
  
  def add color, piece, space
    klass = case piece
            when 'r' then Rook
            when 'n' then Knight
            when 'b' then Bishop
            when 'q' then Queen
            when 'k' then King
            when 'p' then Pawn
            end
    color = if color == 'w' then :white else :black end
    @b[space]= klass.new(color)
    @b.pieces << @b[space]
  end
  
  def move start, _end
    if @b[start]
      m = Move.new start, _end, @b[start]
      @b.move m
      @moves << m
      if @b.moves.count == 1
        m = @b.moves.first
        @b.move m
        @moves << m
      end
    end
  end
  
  def unmove
    @b.unmove @moves.pop unless @moves.empty?
  end
  
  def solve
    (@b.winning? or
     @b.moves.select do |m|
       (count_after(m).zero? or
        (count_after(m) == 1 and
         begin
           move m.start, m.end
           ret = @moves.dup if solve
           unmove
           ret
         end))
     end)
  end
end

UI.new.run