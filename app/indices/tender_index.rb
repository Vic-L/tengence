ThinkingSphinx::Index.define :tender, with: :active_record, primary_key: :thinking_sphinx_id do

  # fields
  indexes description
  indexes ref_no
end