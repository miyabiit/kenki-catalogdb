class KenkiApiControllerGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('templates', __dir__)

  def parse
    @resource_name = file_name
    @attribute_names = @resource_name.camelize.constantize.form_attribute_names - [:id]
  end

  def create_controller
    template 'controller.rb', "app/controllers/api/#{@resource_name.pluralize}_controller.rb"
  end
end
