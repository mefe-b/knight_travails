# Donanım zincirli olduğu için dondurulduğu için kelime
# frozen_string_literal: true

# Şah mat hareket düğümlerini takip eden bir düğüm sınıfı.
class MoveNode
  attr_reader :position, :parent

  # Atın hareketler için olasılıklar
  TRANSFORMATIONS = [
    [1, 2], [-2, -1], [-1, 2], [2, -1],
    [1, -2], [-2, 1], [-1, -2], [2, 1]
  ].freeze

  # Geçmiş konumları takip eden sınıf değişkeni
  @@history = []

  def initialize(position, parent)
    @position = position
    @parent = parent
    @@history.push(position)
  end

  # Geçerli konumdan yeni çocuk düğümleri oluştur.
  def children
    TRANSFORMATIONS
      .map { |t| [@position[0] + t[0], @position[1] + t[1]] }  # Hareket dönüşümleri uygulanır
      .keep_if { |e| MoveNode.valid?(e) }                      # Yalnızca geçerli konumlar tutulur
      .reject { |e| @@history.include?(e) }                     # Ziyaret edilmiş konumlar hariç tutulur
      .map { |e| MoveNode.new(e, self) }                        # Geçerli konumlar için yeni MoveNode nesneleri oluşturulur
  end

  # Konumun tahtadaki sınırlar içinde olup olmadığını kontrol et
  def self.valid?(position)
    position[0].between?(1, 8) && position[1].between?(1, 8)
  end
end

# Düzeni kök düğüme kadar geri izleyen yolu görüntüle.
def display_path(node)
  display_path(node.parent) unless node.parent.nil?  # Kök düğüm gelene kadar döngüde geri git
  p node.position  # Geçerli konumu yazdır
end

# Şah matın başlangıç konumundan hedef konumuna kadar hareketlerini gerçekleştirin.
def knight_moves(start_pos, end_pos)
  queue = []          # Düğümleri keşfetmek için bir kuyruk
  current_node = MoveNode.new(start_pos, nil)  # Başlangıç pozisyonundan başla

  # Hedef pozisyonu ulaşana kadar aramaya devam et
  until current_node.position == end_pos
    current_node.children.each { |child| queue.push(child) }  # Çocukları kuyruğa ekle
    current_node = queue.shift  # Kuyruktan bir sonraki düğümü işleyin
  end

  display_path(current_node)  # Başlangıçtan sona kadar yolu görüntüle
end

# Örnek kullanım: Atın (1, 1) konumundan (8, 8) konumuna kadar yolunu bul.
knight_moves([1, 1], [8, 8])
