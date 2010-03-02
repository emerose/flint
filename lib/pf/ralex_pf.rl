# An example subclassing of Ralex

class RalexPf < Ralex
      
  %%{ 

  machine ralex_pf;
  include ralex_base "ralex_base.rl";

  # new compound token definitions

  
  id = (alnum | '_' | '-' | '.' )+
    @collect_token
    >{ start_token(:ID) }
  ; 

  macroref = '$' (alnum | '_' | '-' | '.' )+
       @collect_token
    >{ start_token(:ID) }
  ;

  tableref = '<' (alnum | '_' | '-' | '.' )+ @collect_token '>'
    @collect_token
    >{ start_token(:TABLEREF) }
  ;

  range = '>' '<'
    @collect_token
    >{ start_token(:PORTRANGE) }
    ;

  inverserange = '<' '>'
    @collect_token
    >{ start_token(:PORTINVERSERANGE) }
    ;

  lessorequal  = '<' '='
    @collect_token
    >{ start_token(:LESSOREQUAL) }
    ;

  greaterorequal = '>' '='
    @collect_token
    >{ start_token(:GREATEROREQUAL) }
    ;


  arrow = '-' '>'
    @collect_token
    >{ start_token(:ARROW) }
    ;

  token = ( id
            | ipaddr
            | ipnet
            | macroref 
	    | tableref
            | number
            | percentage
            | bytecount
            | range
            | inverserange
            | lessorequal
            | greaterorequal
	    | arrow
	    | ralex_specials
	    | hashcomment
	    | quote ) %{ finish_token; };


  unknown = ( any - (space | token) ) @collect_token
    >{ start_token(:UNKNOWN) }
    %{ finish_token; }
    ;
  
  main := ( token | space | unknown )**
  ;

}%%


    def transform_token(tclass, tok)

        if (key = @keywords.fetch(tok.downcase, nil))
            return key, Keyword.new(tok,key)
        end    
        return [tclass, tok]
    end

    
    def initialize(verbose=nil,keywords={})
        super(verbose)
        @keywords = keywords


        %% write data;
    end

    def ragel_machine(data,stack=[],top=0)
            %% write init;
        %% write exec;
    end
end


