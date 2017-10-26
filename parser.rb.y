class HsParser
rule
  statement         : NUMBER "`" IDENT "`" list
                    {
                      exp_array = val.reject { |e| e == "`" }
                      hs = HS.new(
                        receiver: exp_array[0],
                        method: exp_array[1],
                        args: exp_array[2..-1]
                      )
                      hs.call
                    }
                    | IDENT NUMBER list
                    {
                      exp_array = val
                      hs = HS.new(
                        receiver: exp_array[1],
                        method: exp_array[0],
                        args: exp_array[2..-1]
                      )
                      hs.call
                    }
  list_items        : number
                    { result = [val[0]] }
                    | list_items "," number
                    { result << val[2] }
  list              : "[" "]"
                    { result = [] }
                    | "[" list_items "]"
                    { result = val[1] }
  number            : NUMBER
                    { result = val[0].to_i }
end

---- header
require 'strscan'
require_relative 'hs'

---- inner
def parse(str)
  s = StringScanner.new(str)
  @q = []
  until s.eos?
    @q << if s.scan(/\d+/)
            [:NUMBER, s.matched]
          elsif s.scan(/\w+/)
            [:IDENT, s.matched]
          elsif s.scan(/\s+/)
            nil
          elsif s.scan(/./)
            [s.matched, s.matched]
          end
  end
  @q.compact!
  do_parse
end

def next_token
  @q.shift
end

---- footer
parser = HsParser.new
begin
  p parser.parse(File.read('./foo.shinjuku').strip)
rescue Racc::ParseError => e
  $stderr.puts e
end
