module NestedForm
    class SimpleBuilder < ::SimpleForm::FormBuilder  
  
  
  def link_to_add(*args, &block)
    options = args.extract_options!.symbolize_keys
    association = args.pop
    options[:class] = [options[:class], "add_nested_fields"].compact.join(" ")
    options["data-association"] = association
    args << (options.delete(:href) || "javascript:void(0)")
    args << options
    @fields ||= {}
    @template.after_nested_form(association) do
      if object.class._decl_rels[association.to_sym].target_class
        model_object = object.class._decl_rels[association.to_sym].target_class.new      
      else
        model = Concept.new
      end
      
      blueprint = fields_for(association, model_object, :child_index => "new_#{association}", &@fields[association])
      blueprint_options = {:id => "#{association}_fields_blueprint", :style => 'display: none'}
      @template.content_tag(:div, blueprint, blueprint_options)
    end
    @template.link_to(*args, &block)
  end
  
  end
end