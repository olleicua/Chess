require 'game'


=begin
b.moves.each do |move|
  b.move move
  b.print
  b.unmove move
end

p b.moves.count
=end

[[['f2', 0],
  ['e7', 0],
  ['g2', 1],
  ['d8', 3]],
 [['e2', 0],
  ['a7', 0],
  ['d1', 1],
  ['a6', 0],
  ['f1', 2],
  ['a5', 0],
  ['f3', 8]]].each do |moves|
  b = Game.new
  moves.each do |space, move|
    b.move b[space].moves(b)[move]
    b.print
  end
end