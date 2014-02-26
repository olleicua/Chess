require 'game'

b = Game.new
b.print

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
  when /^a (white|black) (Rook|Knight|Bishop|Queen|King|Pawn) ([a-h][1-8])$/
    b[$3]= eval($2).new($1.to_sym)
    b.pieces << b[$3]
  when /^r ([a-h][1-8])$/
    b.pop($1)
  when /^m ([a-h][1-8]) ([a-h][1-8])$/
    b.move Move.new $1, $2, b[$1] if piece = b[$1]
    b.move b.moves.first if b.moves.count == 1
  when 't'
    b.toggle_turn
  when 'd'
    binding.pry
  when 'quit' then break
  else next
  end
  b.print
end
