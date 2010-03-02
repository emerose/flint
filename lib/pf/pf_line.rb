require 'multi'

## Parse and analyze Pf rule lines.

class PfLine < Line
    def self.factory(line, parser_opts={ })
        l = new(line)
        unless l.comment?
            l.tag(parser_opts) if parser_opts.fetch(:tag,true)
            l.parse(parser_opts) if parser_opts.fetch(:parse,false)
        end
        l
    end

    def comment?
        !source.empty? && source[0,1] == "#"
    end

    def tag(parser_opts)
        res = PfTagger.new(parser_opts).safe_parse(@source)
        if res
            if res.kind_of? Array
                @tokens = res.compact
            else
                @error = res
            end
        end
    end
    
    def parse(parser_opts)
        res = PfParser.new(parser_opts).safe_parse(@source)
        if res.kind_of? Array
            @ast = res
        else
            @error = res
        end
    end
    
    def renderer
        PfLineRenderer.instance
    end
    
    def initialize(source)
        super(source)

    end

end

class PfLineRenderer < LineRenderer
    def initialize
        super
                
        multi(:render_html, PfTagger::Comment) { |s|
            %[<span class="comment">#{ ERB::Util.h s }</span>]
        }        

        multi(:render_html, PfTagger::PfTableName) { |s|
            %[<span class="table_name">#{ ERB::Util.h s }</span>]
        }        
        
        multi(:render_html, PfTagger::PfTableRef) { |s|
            cssclass = "table_ref"
            %[<a class="#{ cssclass }" href="/search/rules?q=#{ ERB::Util.h s }">#{ ERB::Util.h s }</a>]
        }        
        
    end
end
