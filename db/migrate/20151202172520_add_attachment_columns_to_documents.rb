class AddAttachmentColumnsToDocuments < ActiveRecord::Migration
  def up
    add_attachment :documents, :upload
  end

  def down
    remove_attachment :documents, :upload
  end
end
