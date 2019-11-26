class KenkiScaffoldGenerator < Rails::Generators::NamedBase
  source_root File.expand_path('templates', __dir__)

  def parse
    @resource_name = file_name
    @attribute_names = @resource_name.camelize.constantize.form_attribute_names - [:id]
  end

  def create_controller
    template 'controller.rb', "app/controllers/#{@resource_name.pluralize}_controller.rb"
  end

  def create_views
    empty_directory File.join("app/views", @resource_name.pluralize)
    %W(_form edit index new show).each do |action_name|
      template "views/#{action_name}.html.erb", "app/views/#{@resource_name.pluralize}/#{action_name}.html.erb"
    end
    %W(index show).each do |action_name|
      template "views/#{action_name}.json.jb", "app/views/#{@resource_name.pluralize}/#{action_name}.json.jb"
    end
  end

  private
    def available_views
      %w(index edit show new _form)
    end
end
