# Copyright (c) 2015 The Regents of the University of Michigan.
# All Rights Reserved.
# Licensed according to the terms of the Revised BSD License
# See LICENSE.md for details.


class RestoreTransfer < ActiveRecord::Base

  ### Modifications and Concerns
  include UUIDFormat
  make_uuid :restore_id

  def to_param
    restore_id
  end

  enum status: {
    requested: 0,
    accepted: 1,
    rejected: 2,
    prepared: 3,
    finished: 4,
    cancelled: 5
  }

  attr_accessor :requester
  def requester
    @requester
  end
  def requester=(value)
    @requester=value
  end


  ### Associations
  belongs_to :from_node, :class_name => "Node", :foreign_key => "from_node_id"
  belongs_to :to_node, :class_name => "Node", :foreign_key => "to_node_id"
  belongs_to :bag
  belongs_to :protocol


  ### Static Validations
  validates :restore_id, presence: true, uniqueness: true
  validates :from_node, presence: true
  validates :to_node, presence: true
  validates :bag, presence: true
  validates :protocol, presence: true
  validates :status, presence: true


  ### ActiveModel::Dirty Validations
  validates_with ChangeValidator, on: :update
  validates :restore_id, read_only: true, on: :update
  validates :from_node_id, read_only: true, on: :update
  validates :to_node_id, read_only: true, on: :update
  validates :bag_id, read_only: true, on: :update
  validates :protocol_id, read_only: true, on: :update


  ### Scopes
  scope :updated_after, ->(time) { where("updated_at > ?", time) unless time.blank? }
  scope :with_bag, ->(uuid) {
    unless uuid.blank?
      joins(:bag).where(Bag.table_name => {uuid: uuid})
    end
  }
  scope :with_status, ->(status) {
    unless status.blank?
      where(status: RestoreTransfer.statuses[status])
    end
  }
  scope :with_from_node, ->(namespace) {
    unless namespace.blank?
      joins("INNER JOIN #{Node.table_name} AS from_nodes ON from_nodes.id=#{table_name}.from_node_id")
        .where(from_nodes: {namespace: namespace})
    end
  }
  scope :with_to_node, ->(namespace) {
    unless namespace.blank?
      joins("INNER JOIN #{Node.table_name} AS to_nodes ON to_nodes.id=#{table_name}.to_node_id")
        .where(to_nodes: {namespace: namespace})
    end
  }


end