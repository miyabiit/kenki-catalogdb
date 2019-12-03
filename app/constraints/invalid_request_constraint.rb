class InvalidRequestConstraint
  def initialize
    @patterns = [
      /\.php\z/,
      /\/php/,
    ]
  end
 
  def matches?(request)
    @patterns.any? { |p| p.match(request.path) }
  end
end
