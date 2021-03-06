class ReferentialCompaniesController < ChouetteController
  include ReferentialSupport
  defaults :resource_class => Chouette::Company, :collection_name => 'companies', :instance_name => 'company'
  respond_to :html
  respond_to :xml
  respond_to :json
  respond_to :js, :only => :index

  belongs_to :referential, :parent_class => Referential

  def index
    index! do |format|
      format.html {
        if collection.out_of_bounds?
          redirect_to params.merge(:page => 1)
        end

        @companies = decorate_companies(@companies)
      }

      format.json {
        render json: companies_maps
      }

      format.js {
        @companies = decorate_companies(@companies)
      }
    end
  end

  protected

  def build_resource
    super.tap do |company|
      company.line_referential = referential.line_referential
    end
  end

  def collection
    scope = referential.line_referential.companies
    if params[:line_id]
      line_scope = referential.line_referential.lines.find(params[:line_id]).companies
      scope = line_scope if line_scope.exists?
    end

    @q = scope.search(params[:q])
    ids = @q.result(:distinct => true).pluck(:id)
    scope = scope.where(id: ids)
    if sort_column && sort_direction
      @companies ||= scope.order(sort_column + ' ' + sort_direction).paginate(:page => params[:page])
    else
      @companies ||= scope.order(:name).paginate(:page => params[:page])
    end
  end

  def resource_url(company = nil)
    referential_company_path(referential, company || resource)
  end

  def collection_url
    referential_companies_path(referential)
  end

  def company_params
    fields = [:objectid, :object_version, :name, :short_name, :organizational_unit, :operating_department_name, :code, :phone, :fax, :email, :registration_number, :url, :time_zone]
    fields += permitted_custom_fields_params(Chouette::Company.custom_fields(@referential.workgroup))
    params.require(:company).permit( fields )
  end

  private

  def sort_column
    referential.workbench.companies.column_names.include?(params[:sort]) ? params[:sort] : 'name'
  end
  def sort_direction
    %w[asc desc].include?(params[:direction]) ?  params[:direction] : 'asc'
  end

  def collection_name
    "companies"
  end

  def decorate_companies(companies)
    CompanyDecorator.decorate(
      companies,
      context: {
        referential: referential
      }
    )
  end

  def companies_maps
    @companies.collect do |company|
      { :id => company.id.to_s,
        :objectid => company.raw_objectid,
        :name => company.name,  
      }
    end
  end

end
