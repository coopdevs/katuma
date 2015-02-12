module PublicUrlHelper

  # View and Mailer helper to generate public urls
  #
  # @param model [String]
  # @param id [Integer]
  # @param options [Hash]
  # @return [String]
  def public_url_for(model:, id: nil, options: {})
    [
      protocol,
      host,
      anchor_segment,
      model_segment(model),
      id_segment(id),
      query_string_from(options)
    ].join
  end

  private

  # Returns the single page anchor segment
  #
  # @return [String]
  def anchor_segment
    '/#/'
  end

  # Generates the segment for the model
  #
  # @param model [String]
  # @return [String]
  def model_segment(model)
    model.underscore.pluralize
  end

  # Generates the segment for the id
  #
  # @param id [Integer]
  # @return [String]
  def id_segment(id)
    return '' if id.nil?

    '/' + id.to_s
  end

  # Generates the url parameters from the options hash
  #
  # @param options [Hash]
  # @return [String]
  def query_string_from(options)
    return '' if options == {}

    '?' + options.to_query
  end

  # Generates the host
  #
  # ToDo: find a better way
  #
  # @return [String]
  def host
    'localhost:8000'
  end

  # Generates the protocol
  #
  # ToDo: find a better way
  #
  # @return [String]
  def protocol
    'http://'
  end
end
