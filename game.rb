require 'rubygems'
require 'pry-nav'
require 'util'
require 'pieces'

class Game
  attr_accessor :turn, :pieces
  def initialize
    @turn = :white
    @pieces = []
    @grid = 8.times.map{ 8.times.map{ [nil] } }
    initialize_pieces
  end
  
  def initialize_pieces
    pieces = [Rook, Knight, Bishop, Queen, King, Bishop, Knight, Rook]
    @grid[0] = pieces.map{|klass| [klass.new(:black)]}
    @grid[1] = pieces.map{[Pawn.new(:black)]}
    @grid[6] = pieces.map{[Pawn.new(:white)]}
    @grid[7] = pieces.map{|klass| [klass.new(:white)]}
    @pieces = @grid.flatten.compact
    set_positions
  end
  
  def set_positions
    ('a'..'h').each do |file|
      (1..8).each do |rank|
        space = "#{file}#{rank}"
        self[space].position = space if self[space]
      end
    end
  end
  
  def [] space
    rank, file = Util.space2coord(space)
    if Util.valid_coord? [rank, file]
      @grid[rank][file].last
    else nil end
  end

  def []= space, piece
    rank, file = Util.space2coord(space)
    self[space].position = nil if self[space]
    @grid[rank][file] << piece
    piece.position = space if piece
  end
  
  def pop space
    rank, file = Util.space2coord(space)
    self[space].position = nil if self[space]
    ret = @grid[rank][file].pop
    self[space].position = space if self[space]
    ret
  end
  
  def after_move m
    move m
    ret = yield
    unmove m
    ret
  end
  
  def illegal? m
    after_move(m){winning?}
  end
  
  def move m
    piece = self[m.start]
    self[m.start] =  nil
    self[m.end] = piece
    toggle_turn
  end
  
  def unmove m
    pop(m.end)
    pop(m.start)
    toggle_turn
  end
  
  def toggle_turn
    if @turn == :white then @turn = :black else @turn = :white end
  end
  
  def moves
    @pieces.select{|p| p.color == turn and !p.taken?}\
      .map{|p| p.moves(self)}\
      .flatten(1)\
      .reject{|m| illegal? m}
  end
  
  # include moves that leave you in check
  def all_moves
    @pieces.select{|p| p.color == turn and !p.taken?}\
      .map{|p| p.moves(self)}\
      .flatten(1)
  end
  
  def winning?
    all_moves.any? do |m|
      after_move(m){king.taken?}
    end
  end
  
  def lost?
    moves.empty?
  end
  
  def king
    @pieces.detect do |piece|
      piece.is_a? King and piece.color == turn
    end
  end
  
  def print
    row = ' '
    ('a'..'h').each do |file|
      row << "#{file} "
    end
    row << ' '
    puts Util.color(row, :border)
    (1..8).to_a.reverse.each do |rank|
      row = Util.color(rank.to_s, :border)
      ('a'..'h').each do |file|
        space = "#{file}#{rank}"
        if self[space]
          row << self[space].to_s
        else
          row << Util.color('  ', Util.color_for_space(space))
        end
      end
      row << Util.color(' ', :border)
      puts row
    end
    puts Util.color(' ' * 18, :border)
    if lost?
      toggle_turn
      puts "#{turn} wins"
    else
      puts "#{turn}'s turn"
    end
    puts ''
  end
end

class Action
  attr_accessor :action, :space, :piece, :piece_taken
  def initialize *args
    @action, @space, @piece = args
  end
end

class Move
  attr_accessor :start, :end
  def initialize *args
    @start, @end = args
  end
end