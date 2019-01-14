
File name     : e_util_look_for_instances.e 
Title         : See if a unit was instantiated in the environment
Project       : Utilities examples
Created       : 2019
              :
Description   : See if a specified unit was ever instantiated in the code.
                
                Should be called after generate was done.
  
   Case description:

      A big environment, and we want to know if there is an instance of a
      specific unit. "did someone instantiate a scoreboard?"

  
  who_instance()
  
      Report if there is an instance of the unit type, and if yes - where 
      (in the code) the instantiation was done.
      A hyper link to the instantiating module is printed.
  
      Usage example:
  
      specman -c 'load sample_env; load e_util_look_for_instances; gen; sys.who_instance("scoreboard");sys.who_instance("ref_model"); '
  



<'

extend sys {
    who_instance(name : string) is {
        out();
        var struct_rf              : rf_struct;
        var found_instance         : bool = FALSE;
        var field_rf    : rf_field;
        
        var all_units : list of any_unit = 
          get_all_units(any_unit);
        
        for each (ui) in all_units {
            struct_rf = rf_manager.get_exact_subtype_of_instance(ui);
                        
            if struct_rf != NULL {
                
                if struct_rf.get_name() == name {
                  
                    // Found an instance of this unit, see who instantiates it 
                    
                    field_rf = rf_manager.get_field_of_unit_instance(ui);

                     out("Found an instance of ", name, ": ", ui.e_path(),
                        "\n instantiation done at line ", 
                         field_rf.get_declaration_source_line_num(),
                         " in @",  
                         field_rf.get_declaration_module().get_name()  );
 
                    found_instance = TRUE;
                };
            };
        };
        if not found_instance {
            out("No instance of ", name, " was found");
        };
    };
};

'>
