class DisableFkMessageDigestsNodes < ActiveRecord::Migration

  def up
    remove_foreign_key :message_digests, :nodes
  end

  def down
    add_foreign_key :message_digests, :nodes,
      name: 'message_digests_nodes_id_fk',
      column: 'node_id',
      on_delete: :restrict,
      on_update: :cascade
  end
end
