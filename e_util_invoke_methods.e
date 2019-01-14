File          : e_util_invoke_methods.e
Title         : Invoke methods using reflection 
Project       : Utilities examples
Created       : 2019
              :
Description   :
  
  Iterating over units invoking methods, using reflection.
  
  Assume some subtypes of a unit define some method, and some do not. 
  This utility goes over all the instances of the base unit, and for each 
  of them that defines the requested method - calls it.
  
  Note that this utility has a parameter "params" which is a list of untyped
  - as we do not know the type of the parameters of the methods we are about
  to invoke. So, when calling this utility - have to "unsafe" each of the 
  parameters.
  
  
  (There are other ways to design the environment. For example - define 
  'interface' containing the methods of interest, and define the relevant 
  subtypes as 'implementing the interface'. But here we want to demonstrate 
  'invoke')
  
  To make your users life easier - wrap this method with a macro.
  
  Usage example:
  
  Calling invoke_methods_in_tree():
  
   specman -c 'load e_util_invoke_methods; load sample_env; gen; sys.invoke_methods_in_tree(sys.env, "inject_data", {FALSE.unsafe(); 0xbb.unsafe()})'
  
  
  Calling the wrapping macro:
  

  specman -c 'load e_util_invoke_methods; load sample_env; gen; iterate sys.env inject_data( FALSE, 0xaa)'
or
  specman -c 'load e_util_invoke_methods; load sample_env; load example;test'

  
  
  
  invoke_methods_in_tree() implementation
  
<'
extend sys {
    
    //
    // invoke_methods_in_tree()
    //
    invoke_methods_in_tree(root_unit   : any_unit,
                           method_name : string,
                           params      : list of untyped) is {
        
        var method_rf             : rf_method;      
        
        var child_units_instances : list of any_unit;
        child_units_instances = rf_manager.get_all_unit_instances(root_unit);
        
        for each (u) in child_units_instances {
            method_rf = 
              rf_manager.get_exact_subtype_of_instance(u).get_method(method_name);
            if method_rf != NULL {
                compute(method_rf.invoke_unsafe(u, params));
            };
        };  
    }; 
};
'>


  macro wrapping the methods, saving users from writing "unsafe" in 
parameters list

<'

define <e_util_iterate'action> "iterate <root'exp> <method'name>\(<exp>,...\)" as computed {
    
    result = append(result, "sys.invoke_methods_in_tree(",
                    <root'exp>, ", \"", <method'name>,"\",{");
    
    // Pass the parameters list, after converted to untyped, using unsafe()
    if not (<exps>.is_empty()) {
        for each (arg) in <exps> {
            result = append(result,"(",arg,").unsafe();");
        };
        // remove last ";" from result
        result = str_chop(result,str_len(result)-1); 
    };
    result = append(result,"});");
};


'>

// Example of calling the macro from method:
extend env {
    run() is also {
        iterate me inject_data( FALSE, 0xcc);
    };
};