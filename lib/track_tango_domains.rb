class TrackTangoDomain
  def self.matches?(request)
    request.domain.present? && request.domain == 'utrade.pw'
  end
end