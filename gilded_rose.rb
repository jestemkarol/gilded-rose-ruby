module Inventory

  class Quality
    attr_reader :amount

    def initialize(amount)
      @amount = amount
    end

    def degrade
      @amount -= 1 if amount > 0
    end

    def increase
      @amount += 1 if amount < 50
    end

    def reset
      @amount = 0
    end
  end

  class GenericItem

    def initialize(quality)
      @quality = Quality.new(quality)
    end

    def quality
      @quality.amount
    end

    def update(sell_in)
      @quality.degrade
      @quality.degrade if sell_in < 0
    end
  end

  class AgedBrie

    def self.build(quality, sell_in)
      if sell_in < 0
        Expired.new(quality)
      else
        new(quality)
      end
    end

    class Expired
      def initialize(quality)
        @quality = Quality.new(quality)
      end

      def quality
        @quality.amount
      end

      def update(_)
        @quality.increase
        @quality.increase
      end
    end

    def initialize(quality)
      @quality = Quality.new(quality)
    end

    def quality
      @quality.amount
    end

    def update(_)
      @quality.increase
    end
  end

  class BackstagePass
    def initialize(quality)
      @quality = Quality.new(quality)
    end

    def quality
      @quality.amount
    end

    def update(sell_in)
      @quality.increase
      if sell_in < 10
        @quality.increase
      end
      if sell_in < 5
        @quality.increase
      end
      if sell_in < 0
        @quality.reset
      end
    end
  end
end

class GildedRose
  class GoodCategory
    def build_for(item)
      case item.name
      when "Aged Brie"
        Inventory::AgedBrie.build(item.quality, item.sell_in)
      when "Backstage passes to a TAFKAL80ETC concert"
        Inventory::BackstagePass.new(item.quality)
      else
        Inventory::GenericItem.new(item.quality)
      end
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
      good.update(item.sell_in)
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
