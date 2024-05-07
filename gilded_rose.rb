module Inventory

  class Quality
    attr_reader :amount

    def initialize(amount)
      @amount = amount
    end

    def degrade
      @amount -= 1 if @amount > 0
    end

    def increase
      @amount += 1 if @amount < 50
    end

    def reset
      @amount = 0
    end

    def less_than_50?
      @amount < 50
    end
  end

  class GenericItem
    attr_reader :quality, :sell_in
    def initialize(quality, sell_in)
      @quality = Quality.new(quality)
      @sell_in = sell_in
    end

    def quality
      @quality.amount
    end

    def update
      @quality.degrade
      if @sell_in < 0
        @quality.degrade
      end
    end
  end

  class AgedBrie
    attr_reader :sell_in

    def initialize(quality, sell_in)
      @quality = Quality.new(quality)
      @sell_in = sell_in
    end

    def quality
      @quality.amount
    end

    def update
      @quality.increase
      @sell_in = sell_in - 1
      if sell_in < 0
        @quality.increase
      end
    end
  end

  class BackstagePass
    attr_reader :sell_in

    def initialize(quality, sell_in)
      @quality = Quality.new(quality)
      @sell_in = sell_in
    end

    def quality
      @quality.amount
    end

    def update
      @quality.increase
      if sell_in < 11
        @quality.increase
      end
      if sell_in < 6
        @quality.increase
      end
      @sell_in = sell_in - 1
      if sell_in < 0
        @quality.reset
      end
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
      elsif generic?(item)
        Inventory::GenericItem.new(item.quality, item.sell_in)
      end
    end

    private

    def generic?(item)
      [aged_brie?(item), backstage_passes?(item)].none?
    end
  
    def aged_brie?(item)
      item.name == "Aged Brie"
    end
  
    def backstage_passes?(item)
      item.name == "Backstage passes to a TAFKAL80ETC concert"
    end
  end

  def initialize(items)
    @items = items
  end

  def update_quality
    @items.each do |item|
      next if sulfuras?(item)
      item.sell_in -= 1
      good = GoodCategory.new.build_for(item)
      good.update
      item.quality = good.quality
    end
  end

  private

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
