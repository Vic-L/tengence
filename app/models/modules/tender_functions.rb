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
end