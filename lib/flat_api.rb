class FlatAPI < Oat::Adapter

  def initialize(*args)
    super
    @entities = {}
    @link_templates = {}
    @meta = {}
  end

  def type(*types)
    @root_name = types.first.to_s.pluralize.to_sym
  end

  def properties(&block)
    data.merge! yield_props(&block)
  end

  def property(key, value)
    data[key] = value
  end

  def entity(name, obj, serializer_class = nil, context_options = {}, &block)
    ent = serializer_from_block_or_class(obj, serializer_class, context_options, &block)
    if ent
      ent_hash = ent.to_hash
      entity_hash[name.to_s.pluralize.to_sym] ||= []
      data[:links][name] = ent_hash[:id]
      entity_hash[name.to_s.pluralize.to_sym] << ent_hash
    end
  end

  def entities(name, collection, serializer_class = nil, context_options = {}, &block)
    return if collection.nil? || collection.empty?
    link_name = name.to_s.pluralize.to_sym
    data[:links][link_name] = []

    collection.each do |obj|
      entity_hash[link_name] ||= []
      ent = serializer_from_block_or_class(obj, serializer_class, context_options, &block)
      if ent
        ent_hash = ent.to_hash
        data[:links][link_name] << ent_hash[:id]
        entity_hash[link_name] << ent_hash
      end
    end
  end

  def collection(name, collection, serializer_class = nil, context_options = {}, &block)
    @treat_as_resource_collection = true
    data[:resource_collection] = [] unless data[:resource_collection].is_a?(Array)

    collection.each do |obj|
      ent = serializer_from_block_or_class(obj, serializer_class, context_options, &block)
      data[:resource_collection] << ent.to_hash if ent
    end
  end

  def to_hash
    return data if serializer.top != serializer
    return data[:resource_collection] if @treat_as_resource_collection

    data
  end

  protected

  attr_reader :root_name

  def entity_hash
    if serializer.top == serializer
      @entities
    else
      serializer.top.adapter.entity_hash
    end
  end

  def entity_without_root(obj, serializer_class = nil, &block)
    ent = serializer_from_block_or_class(obj, serializer_class, &block)
    ent.to_hash.values.first.first if ent
  end
end
