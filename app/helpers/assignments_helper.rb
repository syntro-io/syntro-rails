module AssignmentsHelper
  def test_plans_list(assignment)
    if assignment.id
      if assignment.test_plan_id
        TestPlan.where(product_id: assignment.product_id).order('name').collect { |p| [p.name + ' | Version ' + p.version.to_s, p.id] }
      else
        ['None']
      end
    elsif !assignment.product_id.blank?
      TestPlan.where(product_id: assignment.product_id).order('name').collect { |p| [p.name + ' | Version ' + p.version.to_s, p.id] }
    else
      []
    end
  end

  def stencils_list(assignment)
    if assignment.id
      if assignment.stencil_id
        Stencil.where(product_id: assignment.product_id).order('name').collect { |s| [s.name + ' | Version ' + s.version.to_s, s.id] }
      else
        ['None']
      end
    elsif !assignment.product_id.blank?
      Stencil.where(product_id: assignment.product_id).order('name').collect { |s| [s.name + ' | Version ' + s.version.to_s, s.id] }
    else
      []
    end
  end

  def ticket_issues(product_id, product_version = 0)
    issues = {}
    if product_id.present?
      product = Product.find(product_id)
      if product.ticket_project_id.present?
        version = Version.find(product_version)
        if version.ticket_version_id.present?
          issues = Ticket.project_issues(product.ticket_project_id.to_i, version.ticket_version_id.to_i)
        else
          issues = Ticket.project_issues(product.ticket_project_id)
        end
        issues = issues.sort_by { |issue| issue[:id].to_i }.collect { |item| [item[:id] + ' ' + item[:name], item[:id]] }
      end
    end
    issues
  end

  def issues_list(assignment)
    if assignment.id
      if assignment.issues
        Ticket.bug_status(assignment.issues.split(','))
      else
        []
      end
    end
  end

  def version_list(product_id)
    if product_id.blank?
      []
    else
      Version.where(product_id: @assignment.product_id).order('version').collect { |p| [p.version, p.id] }
    end
  end
end
