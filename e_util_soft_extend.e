
File name     : e_util_soft_extend.e
Title         : Soft extend of enum
Project       : Utilities examples
Created       : 2019
              :
Description   :
  
   Extend an enum, adding a value only if the value had not been added before.

   Useful when same enum is used by multiple packages/developers.

  Running the example:
  
  specman -c 'load e_util_soft_extend; load soft_extend_usage_ex; test'

  
 
<'

define <my_soft_extend'statement> "my_soft_extend <type'name>[ ]:[ ]\[<val'name>,...\]" 
              as computed {
   
    var type_rf : rf_type = rf_manager.get_type_by_name(<type'name>);
    assert type_rf != NULL;
    assert type_rf is a rf_enum;
    
   
    var existing_items := type_rf.as_a(rf_enum).get_items();
  
    
    var new_val : string;
    for each in <val'names> {
        new_val = it;
        if not existing_items.has(it.get_name() == new_val) {
            result = append(result, "extend ", <type'name>, " : [", 
                            new_val, "];"); 
        };
    };
};

'>