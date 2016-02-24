class ShopifyClient
  attr_reader :oauth_uid
  attr_reader :oauth_token

  def initialize(oauth_uid, oauth_token)
    @oauth_uid = oauth_uid
    @oauth_token = oauth_token
  end


  def find(external_entity_name)
    ShopifyAPI::Session.temp(@oauth_uid, @oauth_token) do
      # ugly hack, did not find a better way to convert an entity to a  seriable hash (serializable_hash was not recursive)
      get_shopify_entity_constant(external_entity_name).find(:all).map { |x| JSON.parse(x.to_json) }
    end
  end

  def create(external_entity_name, mapped_connec_entity)
    element = update external_entity_name, mapped_connec_entity
    element.id
  end

  def update(external_entity_name, mapped_connec_entity)
    ShopifyAPI::Session.temp(@oauth_uid, @oauth_token) do
      get_shopify_entity_constant(external_entity_name).create mapped_connec_entity
    end
  end

  private
  def get_shopify_entity_constant(external_entity_name)
    "ShopifyAPI::#{external_entity_name}".constantize
  end

end