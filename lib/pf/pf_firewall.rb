class PfFirewall < Firewall
    include ScriptedFirewall
    
    add_command :push_ssh_key,
                :label => "Push SSH Key",
                :script => "pf/push_ssh_key.pbs",
                :job_title => "Push SSH Key"
    add_command :check_connectivity,
                :label => "Check Connectivity",
                :script => "pf/check_connectivity.pbs",
                :job_title => "Check connectivity"
    add_command :acquire_rules,
                :label => "Acquire Rules",
                :script => "pf/acquire_rules.pbs",
                :job_title => "Acquire rules"
    add_command :push_rules,
                :label => "Push Rules",
                :script => "pf/push_rules.pbs",
                :job_title => "Push rules"
        
    def parser
        PfLine
    end
    
    def rule_term_list(rstr,line_offset=0)
        if (rstr.kind_of? String)
            rule_list = get_rules(rstr) 
        else
            rule_list = rstr
        end

        # each term is of the form [type, term, line]
        linenumber = line_offset
        terms = []
        current_table = nil
        
        (rule_list||[]).each { |line|
            linenumber += 1 
            if (line.respond_to? :tokens and line.tokens)
                if current_table
                    
                
                if((line.tokens[0].kind_of? Array ) && ( line.tokens[0][0].kind_of? String ) && line.tokens[0][0] =="table" )
                    tuple = line.tokens
                    tablename = tuple[0][2][0]
                    tree_select(tuple[0]) { |element|
                        if ( element.kind_of? IPAddr or
                             element.kind_of? PortNumber or
                             element.kind_of? Hostname )
                            terms << [:table, [ tablename, element], linenumber]
                        end
                    }
                end

                else
                    
                    
                end
                

                    
                    
                tree_select(line.tokens) { |tuple| 
                    
                    if (tuple.kind_of? PfTagger::TableDefStart)
                        current_table = tuple.table.name
                    end
                    
                    if (tuple.kind_of? PfTagger::TableDefEnd)
                        current_table = nil
                    end
                    
                    #
                    # This is where you add new types of stuff to generate search indexes for.
                    # Here.  This is the only place we should be doing crap with line-by-line
                    # tokens.
                    #
                    if (tuple.kind_of? IPAddr)
                        # mask address of zero means EVERYTHING
                        if tuple.mask_addr != 0
                            if current_table
                                terms << [:table, 
                                          [current_table, tuple],
                                          linenumber]
                                end
                                terms << [:address, tuple, linenumber]
                            end
                    elsif tuple.kind_of? Hostname
                        if current_table
                            terms << [:table, 
                                      [current_table, tuple],
                                      linenumber]
                        end

                        terms << [:host, tuple, linenumber]
                    elsif tuple.kind_of? PortNumber
                        if current_table
                            terms << [:table, 
                                      [current_table, tuple],
                                      linenumber]
                        end
                        terms << [:port, tuple, linenumber]
                    elsif tuple.kind_of? PfTagger::PfTableRef
                        terms << [tuple.table_type, tuple.name, linenumber]
                    end
                    

                }
                
            end
        }
        return terms
    end
    
    ## ---------------------------------------------------------
    def normalize_rules(rules)
        # convert CRLF encoding from form textarea input, to newline
        newrules = rules.gsub("\r\n","\n")
        
        # if the last char is not a newline, append one
        # otherwise pfctl barfs on the last rule
        newrules << "\n" unless rules.slice(-1,1) == "\n"

        newrules
    end
    
end
