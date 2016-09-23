module VersionsHelper
  def list_ticket_versions(product_id)
    versions = []
    products = product_list
    products.each do |product|
      versions << { id: product[2], versions: Ticket.project_version(product[1].to_s) }
    end
    version = versions.select { |version| version[:id] == product_id }
    if version.present?
      version.pop[:versions].collect { |v| [v[:name], v[:id]] }.sort.reverse
    end
  end

  def ticket_version_name(id)
    ids = []
    ticket_version = {}
    if id.present?
      ids.push(id)
      ticket_version = Ticket.versions_info(ids)
    end
    if ticket_version.blank?
      ticket_version[id] = {}
      ticket_version[id][:name] = ''
      ticket_version[id][:description] = ''
    end
    ticket_version[id]
  end
end
