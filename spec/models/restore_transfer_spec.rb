# Copyright (c) 2015 The Regents of the University of Michigan.
# All Rights Reserved.
# Licensed according to the terms of the Revised BSD License
# See LICENSE.md for details.


require 'rails_helper'

describe RestoreTransfer do
  it "has a valid factory" do
    expect(Fabricate(:restore_transfer)).to be_valid
  end

  it "requires a restore_id" do
    instance = Fabricate(:restore_transfer)
    instance.restore_id = nil
    expect(instance).to_not be_valid
  end

  it "updates updated_at" do
    instance = Fabricate(:restore_transfer)
    old_time = instance.updated_at
    instance.status = :cancelled
    instance.save
    expect(instance.updated_at).to be > old_time
  end
end