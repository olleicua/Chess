# -*- coding: utf-8 -*-
class Piece
  attr_accessor :color, :position
  def initialize color
    @color = color
  end
  
  def taken?
    !@position
  end
  
  def move space
    Move.new(position, space, self)
  end
  
  def move_possible? board, coord
    Util.valid_coord?(coord) and (board[Util.coord2space(coord)].nil? or
                                  board[Util.coord2space(coord)].color != color)
  end
  
  def moves_all board, vectors
    ret = []
    rank, file = Util.space2coord(position)
    vectors.each do |v_f, v_r|
      coord = [rank + v_r, file + v_f]
      capture = false
      while move_possible?(board, coord) and !capture
        ret << move(Util.coord2space(coord))
        capture = true if board[Util.coord2space(coord)]
        coord = [coord[0] + v_r, coord[1] + v_f]
      end
    end
    ret
  end
  
  def moves_one board, vectors
    ret = []
    rank, file = Util.space2coord(position)
    vectors.each do |v_f, v_r|
      coord = [rank + v_r, file + v_f]
      if move_possible? board, coord
        ret << move(Util.coord2space(coord))
      end
    end
    ret
  end
  
  def to_s empty, full
    c = Util.color_for_space(position)
    p = if color == c then empty else full end
    Util.color("#{p} ", c)
  end
end

class Rook < Piece
  def self.to_s; 'R'; end
  
  def to_s
    super '♖', '♜'
  end
  
  def moves board
    moves_all board, [[-1, 0], [0, -1], [0, 1], [1,0]]
  end
end

class Knight < Piece
  def self.to_s; 'N'; end
  
  def to_s
    super '♘', '♞'
  end
  
  def moves board
    moves_one board, [[-1, -2], [-2, -1], [-2, 1], [-1, 2],
                      [1, -2], [2, -1], [2, 1], [1, 2]]
  end
end

class Bishop < Piece
  def self.to_s; 'B'; end
  
  def to_s
    super '♗', '♝'
  end
  
  def moves board
    moves_all board, [[-1, -1], [1, -1], [-1, 1], [1,1]]
  end
end

class Queen < Piece
  def self.to_s; 'Q'; end
  
  def to_s
    super '♕', '♛'
  end
  
  def moves board
    moves_all board, [[-1, -1], [0, -1], [1, -1],
                      [-1, 0],           [1,0],
                      [-1, 1],  [0, 1],  [1,1]]
  end
end

class King < Piece
  def self.to_s; 'K'; end
  
  def to_s
    super '♔', '♚'
  end
  
  def moves board
    moves_one board, [[-1, -1], [0, -1], [1, -1],
                      [-1, 0],           [1,0],
                      [-1, 1],  [0, 1],  [1,1]]
  end
end

class Pawn < Piece
  def self.to_s; ''; end
  
  def to_s
    super '♙', '♟'
  end
  
  def moves board
    ret = []
    rank, file = Util.space2coord(position)
    v_r, v_f = case color
               when :white then [-1, 0]
               when :black then [1, 0] end
    coord = [rank + v_r, file + v_f]
    if Util.valid_coord?(coord) and board[Util.coord2space(coord)].nil?
      ret << move(Util.coord2space(coord))
      if (rank == 6 and color == :white) or (rank == 1 and color == :black)
        coord = [rank + v_r + v_r, file + v_f + v_f]
        if Util.valid_coord?(coord) and board[Util.coord2space(coord)].nil?
          ret << move(Util.coord2space(coord))
        end
      end
    end
    (case color
     when :white then [[-1, -1], [-1, 1]]
     when :black then [[1, -1], [1, 1]] end).each do |v_r, v_f|
      coord = [rank + v_r, file + v_f]
      if (Util.valid_coord?(coord) and
          board[Util.coord2space(coord)] and
          board[Util.coord2space(coord)].color != color)
        ret << move(Util.coord2space(coord))
      end
    end
    ret
  end
end