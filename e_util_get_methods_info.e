File          : e_util_get_methods_info.e
Title         : Get methods information
Project       : Utilities examples
Created       : 2019
              :
Description   :
  
   Small example: Goes over all user defined structs, gets all user 
   defined methods, and for each method, prints its header - parameters and 
   return type
  
  Usage example:
  
  specman -c 'load e_util_get_methods_info; load sample_env; sys.show_user_methods()'
  
  
<'
extend sys {
    
    //
    // show_user_methods()
    //
    show_user_methods() is {
 
        var user_types_l_rf : list of rf_type;
        var methods_l_rf    : list of rf_method;

        user_types_l_rf = rf_manager.get_user_types();
        
        
        for each rf_struct in user_types_l_rf {
            if it is a rf_struct (rfs) {
                out("\nStruct ", rfs.get_name(), "\n--------------------");
                
                // go over the struct's methods.
                // note that we call get_declared_methods(), and not get_methods()
                methods_l_rf = rfs.get_declared_methods();
                for each (rfm) in methods_l_rf  {
                    if rfm is not a rf_on_event_method {
                        print_method(rfm);
                    };
                }; // for each in methods_l_rf 
            }; // if it is a rf_struct
        }; // for each in rf_user_structs
    }; // show_user_methods()
    
    
    //
    // print_method()
    //
    print_method(rfm : rf_method) is {
        
        var parameters_l_rf : list of rf_parameter =
          rfm.get_parameters();

        var result_type_rf : rf_type =
          rfm.get_result_type();
        
        out("\nMethod ", rfm.get_name());

        if result_type_rf == NULL {
            out("   method is void");
        } else {
            out("   method returns ", result_type_rf.get_name());
        };
        
        if parameters_l_rf is not empty {
            out("   methods parameters:");
            for each in parameters_l_rf {
                out("     ", it.get_name(),
                    it.is_by_reference() ? " (passed by reference) " : "",
                    " : ", it.get_type().get_name());
            };
            
        } else {
            out("   method has no parameters");
        };
            
      
    }; // print method()
};
'>

