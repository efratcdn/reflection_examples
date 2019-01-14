
File name     : e_util_show_user_macros.e
Title         : Show user defined macros
Project       : Utilities examples
Created       : 2019
              :
Description   : 
  
  Show all the macros the user defined, print a hyper link to the macro code


  Usage example:

    specman -c 'load e_util_show_user_macros; load sample_env; show user macros'

<'
define <e_util_show_macro'command> "show user macros" as {
    var rf_macros : list of rf_macro;
    rf_macros = rf_manager.get_user_macros();
    
    for each (rm) in rf_macros {
        // Printing with "in @" - gives a hyper link to the source
        out("\nMacro ", rm.get_name(), " defined at line ", 
            rm.get_declaration_source_line_num(),
            " in @", rm.get_declaration_module().get_name());
        
        out("   The macro match expression is \"", 
            rm.get_match_expression(), "\"");
    };
};
'>