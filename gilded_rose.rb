class GildedRose

  def initialize(items)
    @items = items
  end

  def update_quality
    @items.each do |item|
      if sulfuras?(item)
      elsif generic?(item)
        handle_generic(item)
      elsif aged_brie?(item)
        handle_aged_brie(item)
      elsif backstage_passes?(item)
        handle_backstage_passes(item)
      end
    end
  end

  private

  def increate_quality(item)
    item.quality += 1 
  end

  def decrease_quality(item)
    item.quality -= 1
  end

  def quality_below_50?(item)
    item.quality < 50
  end

  def handle_generic(item)
    if item.quality > 0
      decrease_quality(item)
    end
    item.sell_in = item.sell_in - 1
    if item.sell_in < 0
      if item.quality > 0
        decrease_quality(item)
      end
    end
  end

  def handle_aged_brie(item)
    if quality_below_50?(item)
      increate_quality(item)
    end
    item.sell_in = item.sell_in - 1
    if item.sell_in < 0
      if quality_below_50?(item)
        increate_quality(item)
      end
    end
  end

  def handle_backstage_passes(item)
    if quality_below_50?(item)
      increate_quality(item)
      if item.sell_in < 11
        if quality_below_50?(item)
          increate_quality(item)
        end
      end
      if item.sell_in < 6
        if quality_below_50?(item)
          increate_quality(item)
        end
      end
    end
    item.sell_in = item.sell_in - 1
    if item.sell_in < 0
      item.quality = item.quality - item.quality
    end
  end

  def generic?(item)
    [aged_brie?(item), backstage_passes?(item), sulfuras?(item)].none?
  end

  def aged_brie?(item)
    item.name == "Aged Brie"
  end

  def backstage_passes?(item)
    item.name == "Backstage passes to a TAFKAL80ETC concert"
  end

  def sulfuras?(item)
    item.name == "Sulfuras, Hand of Ragnaros"
  end
end

class Item
  attr_accessor :name, :sell_in, :quality

  def initialize(name, sell_in, quality)
    @name = name
    @sell_in = sell_in
    @quality = quality
  end

  def to_s()
    "#{@name}, #{@sell_in}, #{@quality}"
  end
end
