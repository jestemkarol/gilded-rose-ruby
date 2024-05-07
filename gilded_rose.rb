module Inventory
  class GenericItem
    attr_reader :quality, :sell_in
    def initialize(quality, sell_in)
      @quality = quality
      @sell_in = sell_in
    end

    def update
      if @quality > 0
        @quality -= 1
      end
      @sell_in = @sell_in - 1
      if @sell_in < 0
        if @quality > 0
          @quality -= 1
        end
      end
    end
  end

  class AgedBrie
    attr_reader :quality, :sell_in
    def initialize(quality, sell_in)
      @quality = quality
      @sell_in = sell_in
    end

    def update
      if @quality < 50
        @quality += 1 
      end
      @sell_in = @sell_in - 1
      if @sell_in < 0
        if @quality < 50
          @quality += 1 
        end
      end
    end
  end

  class BackstagePass
    attr_reader :quality, :sell_in
    def initialize(quality, sell_in)
      @quality = quality
      @sell_in = sell_in
    end

    def update
      if @quality < 50
        @quality += 1 
        if @sell_in < 11
          if @quality < 50
            @quality += 1 
          end
        end
        if @sell_in < 6
          if @quality < 50
            @quality += 1 
          end
        end
      end
      @sell_in = @sell_in - 1
      if @sell_in < 0
        @quality = @quality - @quality
      end
    end
  end

  class Sulfuras
    attr_reader :quality, :sell_in
    def initialize(quality, sell_in)
      @quality = quality
      @sell_in = sell_in
    end

    def update
    end
  end
end

class GildedRose
  class GoodCategory
    def build_for(item)
      if aged_brie?(item)
        Inventory::AgedBrie.new(item.quality, item.sell_in)
      elsif backstage_passes?(item)
        Inventory::BackstagePass.new(item.quality, item.sell_in)
      elsif sulfuras?(item)
        Inventory::Sulfuras.new(item.quality, item.sell_in)
      elsif generic?(item)
        Inventory::GenericItem.new(item.quality, item.sell_in)
      end
    end

    private

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

  def initialize(items)
    @items = items
  end

  def update_quality
    @items.each do |item|
      good = GoodCategory.new.build_for(item)
      good.update
      item.quality = good.quality
      item.sell_in = good.sell_in
    end
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
