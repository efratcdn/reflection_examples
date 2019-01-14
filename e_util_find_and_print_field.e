File name     : e_util_find_and_print_field.e
Title         : Print fields that match pattern
Project       : Utilities examples
Created       : 2019
              :
Description   : 
  
 
  For given struct instance, look for fields that their names match a pattern 
  and print the values of these fields. 

  specman -c 'load e_util_find_and_print_field; load sample_env; gen; sys.print_field_value(sys.env, "addr"); sys.print_field_value(sys.env, "size")'
  
  
<'

extend sys {
    
    //
    // print_field_value()
    //

    print_field_value(input_struct  : base_struct,
                      field_pattern : string) is {
        
        out("\n Struct ", input_struct, " looking for fields that have \"",
           field_pattern, "\" in their name");
        
        var struct_rf : rf_struct =
          rf_manager.get_exact_subtype_of_instance(input_struct);
          
        var fields_l_rf : list of rf_field =
          struct_rf.get_fields();
        
        var matching_fields_l_rf : list of rf_field;

        for each in fields_l_rf {
            if str_match(it.get_name(), 
                         append("...",field_pattern,"...")) {
                matching_fields_l_rf.add(it);
            };
        };
        
        if matching_fields_l_rf is empty {
            out("\n   There is no field that its name matches \"", 
                field_pattern, "\"");
            return;
        };
        
        // get the value of each of this fields
        
        var field_type_rf       : rf_type;
        var field_value_string  : string;
        var field_value_untyped : untyped;
        
        for each (rff) in matching_fields_l_rf {
            
            field_type_rf = rff.get_type(); 

            // get the value of this field in this struct instance
            field_value_untyped = rff.get_value_unsafe(input_struct);

            // convert the value to string, so can be printed
            field_value_string = 
              field_type_rf.value_to_string(field_value_untyped);
            
            out("\n    The field ", rff.get_name(),
                " of type : ", field_type_rf.get_name(),
                ", its value is : ", field_value_string);
        };
    }; // print_field_value()
};
'>

