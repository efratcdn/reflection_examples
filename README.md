
* Title       : Reflection examples 
* Version     : 1.0
* Requires    : Specman {16.11..}
* Modified    : January 2019
* Description :

[ More e code examples in https://github.com/efratcdn/spmn-e-utils ]



Multiple examples of utilities using Specman e reflection. 

Most of the utilities/examples are rather short, and can be used for learning 
or as building blocks for more advanced capabilities.


1) Look for unit instances
2) Check for dead code
3) Soft extend
4) Get methods information
5) Print fields that match pattern
6) Show user defined macros
7) Invoke methods, iterate
8) Set value to struct's fields


==========================
1) Look for unit instances
==========================

   e_util_look_for_instances.e

   Case description:

      A big environment, and we want to know if there is an instance of
      a specific unit. "did someone instantiate a scoreboard?"


  who_instance
  
      Report if there is an instance of the unit type, and if yes - where 
      (in the code) the instantiation was done.
      A hyper link to the instantiating module is printed.
 
 
  Usage example:
  
      specman -c 'load sample_env; load e_util_look_for_instances; gen; sys.who_instance("scoreboard");sys.who_instance("ref_model"); '


======================
2) Check for dead code
======================
  

     e_util_check_dead_code.e

     Goes over all user defined methods, and for each of them checks if there is any place 
     in the code in which this method is being called.
  
  
     The method check_dead_code() can be called directly, and also - to be part of HAL.
  
     When called as part of HAL, should use the HAL def file, named here hal_ext.def, 
     which contains the definition of the new check.
  
  
  
  Usage examples:

  -) Stand alone, no HAL:
  
  specman -c '#define NO_HAL;  config misc -lint_mode = TRUE; load sample_env.e; load e_util_check_dead_code; lint_manager.check_dead_code()'

  
  -) Using HAL:

  
  hal -rulefile hal_ext.def e_util_check_dead_code.e sample_env.e
  xmbrowse -rulefile hal_ext.def -sortby severity -sortby category -sortby tag hal.log

     You will see the new check in Severity Warning, MY_CHECKS



==============
3) Soft extend
==============

   e_util_soft_extend.e

   Extend an enum, adding a value only if the value had not been added before.

   Useful when same enum is used by multiple packages/developers.


  Usage example:

  specman -c 'load e_util_soft_extend; load soft_extend_usage_ex; test'



==========================
4) Get methods information
==========================

  e_util_get_methods_info.e

  Small example: Goes over all user defined structs, gets all user defined methods, and
   for each method, prints its header - parameters and return type
  
  Usage example:
  
  specman -c 'load e_util_get_methods_info;  load sample_env; sys.show_user_methods()'
  

==================================
5) Print fields that match pattern
==================================

  e_util_find_and_print_field.e

  For given struct instance, look for fields that their names match a pattern 
  and print the values of these fields. 

  Usage example:

  specman -c 'load e_util_find_and_print_field; load sample_env; gen; sys.print_field_value(sys.env, "addr"); sys.print_field_value(sys.env, "size")'

  

===========================
6) Show user defined macros
===========================

  e_util_show_user_macros.e

  Show all the macros the user defined, print a hyper link to the macro code


  Usage example:

    specman -c 'load e_util_show_user_macros; load sample_env; show user macros'




==========================
7) Invoke methods, iterate
==========================

  e_util_invoke_methods.e

  Iterating over units invoking methods, using reflection.
  
  Assume some subtypes of a unit define some method, and some do not. This utility 
  goes over all the instances of the base unit, and for each of them that defines 
  the requested method - calls it.

  Usage examples:

 specman -c 'load e_util_invoke_methods; load sample_env; gen; sys.invoke_methods_in_tree(sys.env, "inject_data", {FALSE.unsafe(); 0xbb.unsafe()})'

  specman -c 'load e_util_invoke_methods; load sample_env; gen; iterate sys.env inject_data( FALSE, 0xaa)'

  specman -c 'load e_util_invoke_methods; load sample_env; load example;test'



===============================
8) Set value to struct's fields
===============================

  e_util_set_fields.e

  Going over all structs under specified root, and init its fields. 'init' means -
  assign the value '0' (or its equivalent in field's type).


  Usage example:

  specman -c 'load e_util_set_fields; load sample_env; gen; print sys.env.scoreboard.items; sys.init_fields_under_root(sys.env); print sys.env.scoreboard.items '
