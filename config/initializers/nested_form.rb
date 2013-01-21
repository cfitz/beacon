module NestedForm
    class SimpleBuilder < ::SimpleForm::FormBuilder  
  
  
  def link_to_add(*args, &block)
    options = args.extract_options!.symbolize_keys
    association = args.pop
    
    unless object.respond_to?("#{association}_attributes=")
      raise ArgumentError, "Invalid association. Make sure that accepts_nested_attributes_for is used for #{association.inspect} association."
    end
    
    model_object = object.class._decl_rels[association.to_sym].target_class.new
    
    
    options[:class] = [options[:class], "add_nested_fields"].compact.join(" ")
    options["data-association"] = association
    options["data-blueprint-id"] = fields_blueprint_id = fields_blueprint_id_for(association)  
    args << (options.delete(:href) || "javascript:void(0)")
    args << options
    
    @fields ||= {}
    @template.after_nested_form(fields_blueprint_id) do
      blueprint = {:id => fields_blueprint_id, :style => 'display: none'}
      #block, options = @fields[fields_blueprint_id].values_at(:block, :options)
      options[:child_index] = "new_#{association}"
      blueprint[:"data-blueprint"] = fields_for(association, model_object, options, &block).to_str
      @template.content_tag(:div, nil, blueprint)
    
    end
    @template.link_to(*args, &block)
  end


  end
end