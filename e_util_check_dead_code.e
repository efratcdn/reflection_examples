
File name     : e_util_check_for_dead_code.e
Title         : Check for dead code
Project       : Utilities examples
Created       : 2019
              :
Description   : Checks if there is a method that was defined and is never
                called.
                Check is static, that is - this is not code coverage, not 
                running tests.
                
                Here we check "does someone calls this method". Similarly, 
                we can implement also checks like "who uses this macro?", etc.
                  
  
   check_dead_code()
  
     Goes over all user defined methods, and for each of them checks if 
     there is any place in the code in which this method is being called.
  
  
     The method check_dead_code() can be called directly, and also - to be 
     part of HAL.
  
     When called as part of HAL, should use the HAL def file, named here 
     hal_ext.def, which contains the definition of the new check.
  
  
  
  Usage example:

  1) Stand alone, no HAL:
  
  specman -c '#define NO_HAL;  config misc -lint_mode = TRUE; load sample_env.e; load e_util_check_dead_code; lint_manager.check_dead_code()'

  
  2) Using HAL:
  

  
  hal -rulefile hal_ext.def e_util_check_dead_code.e sample_env.e
  xmbrowse -rulefile hal_ext.def -sortby severity -sortby category -sortby tag hal.log

     You will see the new check in Severity Warning, MY_CHECKS

  

<'

lint_rule CHECK_DEAD_CODE "Method defined but never called";

extend lint_manager {
    
    check_dead_code() is {
        
        var user_types_l_rf : list of rf_type;
        var methods_l_rf    : list of rf_method; 
        var l_number        : int;
        var method_name     : string;
        var module_rf       : rf_module;
        
        user_types_l_rf = rf_manager.get_user_types();

        for each rf_struct (srf) in user_types_l_rf {
            methods_l_rf = srf.get_declared_methods();
            
            for each (rfm) in methods_l_rf {
                
                // get all references to this entity
                if get_entity_references(rfm) is empty {
                    module_rf = rfm.get_declaration_module();
                    l_number = rfm.get_declaration_source_line_num();
                    method_name = rfm.get_name();
                    
                    out("Method ", method_name, " defined at line ", l_number, 
                        " in @", module_rf.get_name(), " is never called");
#ifndef NO_HAL {
                // HAL:
                notify_at(CHECK_DEAD_CODE,  
                          append("Method defined and never called %s", method_name),
                          module_rf.get_full_file_name(), l_number);
                
}; // HAL
 
                };
            };
        };
    };
    
   
   
    
    
    user_analysis() is also {
        check_dead_code();
    };
};
'>