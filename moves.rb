require 'game'

b = Game.new
b.print
moves = []

while true
  print '> '
  STDOUT.flush
  command = gets.chomp
  case command
  when 'moves'
    b.moves.each do |m|
      b.after_move(m) do
        puts "#{m}: #{b.moves.count}"
      end
    end
  when /^a ?([wb]) ?([rnbqkp]) ?([a-h][1-8])$/i
    klass = case $2
            when 'r' then Rook
            when 'n' then Knight
            when 'b' then Bishop
            when 'q' then Queen
            when 'k' then King
            when 'p' then Pawn
            end
    color = if $1 == 'w' then :white else :black end
    b[$3]= klass.new(color)
    b.pieces << b[$3]
  when /^r ?([a-h][1-8])$/
    b.pop($1)
  when /^m ?([a-h][1-8]) ?([a-h][1-8])$/
    if b[$1]
      m = Move.new $1, $2, b[$1]
      b.move m
      moves << m
      if b.moves.count == 1
        m = b.moves.first
        b.move m
        moves << m
      end
    end
  when 'u'
    b.unmove moves.pop unless moves.empty
  when 't'
    b.toggle_turn
  when 'd'
    binding.pry
  when 'quit' then break
  else next
  end
  b.print
end
