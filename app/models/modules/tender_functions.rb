module TenderFunctions
  def in_house?
    !!(ref_no =~ /^InHouse-/)
  end

  def buyer_name_and_company
    "#{buyer_name} (#{buyer_company_name})"
  end

  def ref_no_for_display
    if ref_no =~ /^tengence-/
      "-"
    else
      ref_no
    end
  end

  def is_gebiz?
    !!(external_link =~ /gebiz.gov/)
  end

  def self.included(base)
    base.class_eval do
      scope :gebiz, -> {where("external_link like '%gebiz.gov%'")}
      scope :non_gebiz, -> {where.not("external_link like '%gebiz.gov%'")}
    end
  end

  def watched? tender_ids
    tender_ids.include?(self.ref_no)
  end
end