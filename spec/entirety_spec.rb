require 'spec_helper'

RSpec.describe ForceLayout::Entirety, 'force_layout' do
  before(:all) do
    @file = File.read(File.expand_path('./test_data.json', File.dirname(__FILE__)))
    @entirety_layout = ForceLayout::Entirety.new
  end

  context 'Parse data to objects' do
    it 'import data' do
      @entirety_layout.import_data(@file)
      expect(ForceLayout::Node.count).to eq 4
      expect(ForceLayout::Edge.count).to eq 3
    end
  end

  context 'Init position' do
    it 'init point' do
      expect(ForceLayout::Node.all[0].point).to be_nil
      @entirety_layout.init_nodes_point
      expect(ForceLayout::Node.all[0].point).not_to be_nil
    end

    it 'init spring' do
      expect(ForceLayout::Edge.all[0].spring).to be_nil
      @entirety_layout.init_edges_spring
      expect(ForceLayout::Edge.all[0].spring).not_to be_nil
    end
  end

  context 'Update' do
    it 'update coulombs law' do
      expect(ForceLayout::Node.all[0].point.accelerate.x).to eq 0
      @entirety_layout.update_coulombs_law
      expect(ForceLayout::Node.all[0].point.accelerate.x).not_to eq 0
    end

    it 'update hookes law' do
      origin_accelerate_x = ForceLayout::Node.all[0].point.accelerate.x
      @entirety_layout.update_hookes_law
      expect(ForceLayout::Node.all[0].point.accelerate.x).not_to eq origin_accelerate_x
    end

    it 'attract to center' do
      origin_accelerate_x = ForceLayout::Node.all[0].point.accelerate.x
      @entirety_layout.attract_to_center
      expect(ForceLayout::Node.all[0].point.accelerate.x).not_to eq origin_accelerate_x
    end

    it 'update velocity' do
      @entirety_layout.update_velocity(0.02)
      expect(ForceLayout::Node.all[0].point.accelerate.x).to eq 0
      expect(ForceLayout::Node.all[0].point.velocity.x).not_to eq 0
    end

    it 'update position' do
      origin_position_x = ForceLayout::Node.all[0].point.position.x
      @entirety_layout.update_position(0.02)
      expect(ForceLayout::Node.all[0].point.position.x).not_to eq origin_position_x
    end

    it 'get total energy' do
      expect(@entirety_layout.total_energy).not_to eq 0
    end
  end
end
