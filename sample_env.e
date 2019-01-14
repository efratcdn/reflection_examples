
  sample_env.e:
  
  Code to be used to demonstrate the utilities.
  
  
<'
import types_def_ex.e;

define BUS_WIDTH 32;
define BASE_ADDR 0x20;

type agent_kind : [MASTER, SLAVE, ARBITER];
type item_kind  : [UNDEFINED, DATA, CTRL];

struct data_item {
    kind     : item_kind;
    %add     : int (bits : BUS_WIDTH);
    %val     : byte;
    legal    : bool;
};

unit scoreboard {
    items[4] : list of data_item;
    
    add_item() is {
        out("doing nothing....");
    };
    match_item(item : data_item) is {
        out("doing nothing....");
    };
};

unit ref_model {
    max_size : byte;
    
    expected_item(input : data_item, 
                  address: *int (bits : BUS_WIDTH)) : data_item is {
    };
    
};

unit env {
    first_address    : int (bits : BUS_WIDTH);
    max_addr         : uint;
    first_item       : data_item;
    all_addresses[4] : list of int (bits : BUS_WIDTH);
    
    keep soft first_address == 100;
    keep soft max_addr == 200;
    keep for each in all_addresses {
        it == index;
    };
};

extend sys {
    env : env is instance;
};

extend env {
    scoreboard : scoreboard is instance;
    master     : MASTER agent is instance;
    slave      : SLAVE agent is instance;
    arbiter    : ARBITER agent is instance;

    check() is also {
        scoreboard.add_item();
    };
    inject_data(with_error : bool,
                data       : byte) is {
        message(LOW, "injecting ", data);
        // ...
    };
    
};

unit agent {
    kind        : agent_kind;
};
extend MASTER agent {
    inject_data(with_error : bool,
                data       : byte) is {
        message(LOW, "injecting ", data);
        // ...
    };
};
extend SLAVE agent {
    inject_data(with_error : bool,
                data       : byte) is {
        message(LOW, "injecting ", data);
        /// ...
    };
};

define <stam'action> "send <val'num>" as {
    var f : uint = <val'num> * 8;
};
'>
