
File name     : e_util_set_fields.e
Title         : Setting fields values, using reflection
Project       : Utilities examples
Created       : 2019
              :
Description   : This utility goes over structs, and init all its fields.
  
  This is an example, to show how to user the reflection set_field_value.
  
  Going over all structs under specified root, and init its fields. 
  'init' means - assign the value '0' (or its equivalent in field's type).
  
  Skipping units, initialization only structs.
  
  Ideas for enhancements:
  
      Allow the user to specify which fields to set/ignore
  
      Here we go over all structs under specified root, can also go over 
      all structs that are of some base type
  
      Can decide to set the field value to some default value, instead of init
  
  
  
  Usage example:

  specman -c 'load e_util_set_fields; load sample_env; gen; print sys.env.scoreboard.items; sys.init_fields_under_root(sys.env); print sys.env.scoreboard.items '
  

<'

extend sys {
  
    //
    // init_fields_under_root()
    //
    init_fields_under_root(unit_root : any_unit) is {
        
        // iterate on all instances under unit_root
        var iterator : instance_iterator = new;
        iterator.start(unit_root);
        
        var cur_struct           : any_struct;
        var struct_rf            : rf_struct;
        var fields_l_rf          : list of rf_field;
        
        repeat {
            cur_struct = iterator.get_current_instance();

            if cur_struct is a any_unit {
                // skip units
                continue;
            };
          
            struct_rf   = rf_manager.get_struct_of_instance(cur_struct);
            fields_l_rf = struct_rf.get_fields();

            for each (rff) in fields_l_rf {
                if rff.get_type() is a rf_scalar { 
                    rff.set_value_unsafe(cur_struct, 0.unsafe());
                };
            };
            
        } until not iterator.next();
   };
    
};
'>