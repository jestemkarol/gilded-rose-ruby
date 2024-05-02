require 'rspec'
require 'simplecov'
SimpleCov.start

require File.join(File.dirname(__FILE__), 'gilded_rose')

describe GildedRose do
  it "does not change the name" do
    items = [Item.new("foo", 0, 0)]
    GildedRose.new(items).update_quality()
    expect(items[0].name).to eq "foo"
  end

  it 'prints the report' do
    report_lines = []
    items = [
      Item.new(name="+5 Dexterity Vest", sell_in=10, quality=20),
      Item.new(name="Aged Brie", sell_in=2, quality=0),
      Item.new(name="Elixir of the Mongoose", sell_in=5, quality=7),
      Item.new(name="Sulfuras, Hand of Ragnaros", sell_in=0, quality=80),
      Item.new(name="Sulfuras, Hand of Ragnaros", sell_in=-1, quality=80),
      Item.new(name="Backstage passes to a TAFKAL80ETC concert", sell_in=15, quality=20),
      Item.new(name="Backstage passes to a TAFKAL80ETC concert", sell_in=10, quality=49),
      Item.new(name="Backstage passes to a TAFKAL80ETC concert", sell_in=5, quality=49),
      # This Conjured item does not work properly yet
      Item.new(name="Conjured Mana Cake", sell_in=3, quality=6), # <-- :O
    ]

    days = 2

    gilded_rose = GildedRose.new items
    (0...days).each do |day|
      report_lines << "-------- day #{day} --------"
      report_lines << "name, sellIn, quality"
      items.each do |item|
        report_lines << item.to_s
      end
      report_lines << ""
      gilded_rose.update_quality
    end

    expect(report_lines).to eq ["-------- day 0 --------", "name, sellIn, quality", "+5 Dexterity Vest, 10, 20", "Aged Brie, 2, 0", "Elixir of the Mongoose, 5, 7", "Sulfuras, Hand of Ragnaros, 0, 80", "Sulfuras, Hand of Ragnaros, -1, 80", "Backstage passes to a TAFKAL80ETC concert, 15, 20", "Backstage passes to a TAFKAL80ETC concert, 10, 49", "Backstage passes to a TAFKAL80ETC concert, 5, 49", "Conjured Mana Cake, 3, 6", "", "-------- day 1 --------", "name, sellIn, quality", "+5 Dexterity Vest, 9, 19", "Aged Brie, 1, 1", "Elixir of the Mongoose, 4, 6", "Sulfuras, Hand of Ragnaros, 0, 80", "Sulfuras, Hand of Ragnaros, -1, 80", "Backstage passes to a TAFKAL80ETC concert, 14, 21", "Backstage passes to a TAFKAL80ETC concert, 9, 50", "Backstage passes to a TAFKAL80ETC concert, 4, 50", "Conjured Mana Cake, 2, 5", ""]
  end

  describe 'Backstage passes to a TAFKAL80ETC concert scenarios' do
    let(:items) do 
      [
        Item.new("Backstage passes to a TAFKAL80ETC concert", 8, 20),
        Item.new("Backstage passes to a TAFKAL80ETC concert", 4, 20),
        Item.new("Backstage passes to a TAFKAL80ETC concert", 0, 20)
      ]
    end

    it 'returns expected backstage passes quality' do
      GildedRose.new(items).update_quality
      expect(items.map(&:quality)).to eq [22, 23, 0]
    end
  end

  describe 'Aged Brie scenarios' do
    let(:items) do
      [
        Item.new("Aged Brie", 0, 20)
      ]
    end

    it 'returns expected aged brie quality' do
      GildedRose.new(items).update_quality
      expect(items.map(&:quality)).to eq [22]
    end
  end

  describe 'Generic items scenarios' do
    let(:items) do
      [
        Item.new("foo", 0, 0),
        Item.new("foo", 0, 20)
      ]
    end

    it 'returns expected generic items quality' do
      GildedRose.new(items).update_quality
      expect(items.map(&:quality)).to eq [0, 18]
    end
  end
end
